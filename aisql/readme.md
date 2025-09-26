# Ecommerce SQL Generation Bot

A Python script that uses OpenAI's GPT models to generate SQL queries from natural language questions for an ecommerce database.

## Database Schema

The bot works with a standard ecommerce database containing:

- **Categories**: Product categories (Electronics, Clothing, Books, etc.)
- **Products**: Product information with pricing and inventory
- **Customers**: Customer profiles and contact information
- **Addresses**: Shipping addresses linked to customers
- **Orders**: Order headers with status and totals
- **Order Items**: Detailed line items for each order
- **Payments**: Payment information and transaction status

## Sample Questions

- "What are the top-selling products in the last 30 days?"
- "What are the top 3 categories by total revenue?"
- "Which customers do not have a default shipping address?"
- "How many orders are currently in PENDING payment status?"
- "Who are the top 3 customers by cumulative order amount?"

## Output

Results are saved as JSON files with:
- Generated SQL queries
- Raw database results
- Human-friendly explanations
- Error handling information