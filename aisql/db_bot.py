import json
from openai import OpenAI
import os
import sqlite3
from time import time

print("Running db_bot.py!")

fdir = os.path.dirname(__file__)
def getPath(fname):
    return os.path.join(fdir, fname)

# SQLITE
sqliteDbPath = getPath("aidb.sqlite")
setupSqlPath = getPath("setup_ecommerce.sql")
setupSqlDataPath = getPath("setupData_ecommerce.sql")

# Erase previous db
if os.path.exists(sqliteDbPath):
    os.remove(sqliteDbPath)

sqliteCon = sqlite3.connect(sqliteDbPath) # create new db
sqliteCursor = sqliteCon.cursor()
with (
        open(setupSqlPath) as setupSqlFile,
        open(setupSqlDataPath) as setupSqlDataFile
    ):

    setupSqlScript = setupSqlFile.read()
    setupSQlDataScript = setupSqlDataFile.read()

sqliteCursor.executescript(setupSqlScript) # setup tables and keys
sqliteCursor.executescript(setupSQlDataScript) # setup tables and keys

def runSql(query):
    result = sqliteCursor.execute(query).fetchall()
    return result

# OPENAI
configPath = getPath("config.json")
print(configPath)
with open(configPath) as configFile:
    config = json.load(configFile)

openAiClient = OpenAI(api_key = config["openaiKey"])
openAiClient.models.list() # check if the key is valid (update in config.json)

def getChatGptResponse(content):
    stream = openAiClient.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": content}],
        stream=True,
    )

    responseList = []
    for chunk in stream:
        if chunk.choices[0].delta.content is not None:
            responseList.append(chunk.choices[0].delta.content)

    result = "".join(responseList)
    return result


# strategies
commonSqlOnlyRequest = " Give me a sqlite select statement that answers the question. Only respond with sqlite syntax. If there is an error do not explain it!"
strategies = {
    "zero_shot": setupSqlScript + commonSqlOnlyRequest,
    "single_domain_double_shot": (setupSqlScript +
                   " How many orders are in PENDING status? " +
                   " \nSELECT order_status, COUNT(*) AS cnt FROM orders GROUP BY order_status;\n " +
                   commonSqlOnlyRequest)
}

questions = [
  "What are the top-selling products in the last 30 days?",
  "What are the top 3 categories by total revenue?",
  "Which customers do not have a default shipping address?",
  "How many orders are currently in PENDING payment status?",
  "Who are the top 3 customers by cumulative order amount?",
  "What is the average order value by customer?",
  "Which products are out of stock?",
  "What is the total revenue for each month this year?"
]

def sanitizeForJustSql(value):
    gptStartSqlMarker = "```sql"
    gptEndSqlMarker = "```"
    if gptStartSqlMarker in value:
        value = value.split(gptStartSqlMarker)[1]
    if gptEndSqlMarker in value:
        value = value.split(gptEndSqlMarker)[0]

    return value

for strategy in strategies:
    responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
    questionResults = []
    print("########################################################################")
    print(f"Running strategy: {strategy}")
    for question in questions:

        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("Question:")
        print(question)
        error = "None"
        try:
            getSqlFromQuestionEngineeredPrompt = strategies[strategy] + " " + question
            sqlSyntaxResponse = getChatGptResponse(getSqlFromQuestionEngineeredPrompt)
            sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
            print("SQL Syntax Response:")
            print(sqlSyntaxResponse)
            queryRawResponse = str(runSql(sqlSyntaxResponse))
            print("Query Raw Response:")
            print(queryRawResponse)
            #friendlyResultsPrompt = "I asked a question \"" + question +"\" and the response was \""+queryRawResponse+"\" Please, just give a concise response in a more friendly way? Please do not give any other suggests or chatter."
            betterFriendlyResultsPrompt = "I asked a question: \"" + question +"\" and I queried this database " + setupSqlScript + " with this query " + sqlSyntaxResponse + ". The query returned the results data: \""+queryRawResponse+"\". Could you concisely answer my question using the results data?"
            friendlyResponse = getChatGptResponse(betterFriendlyResultsPrompt)
            print("Friendly Response:")
            print(friendlyResponse)
        except Exception as err:
            error = str(err)
            print(err)

        questionResults.append({
            "question": question,
            "sql": sqlSyntaxResponse,
            "queryRawResponse": queryRawResponse,
            "friendlyResponse": friendlyResponse,
            "error": error
        })

    responses["questionResults"] = questionResults

    with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
        json.dump(responses, outFile, indent = 2)


sqliteCursor.close()
sqliteCon.close()
print("Done!")