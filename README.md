
# Pizza Sales Data Analysis

This repository contains SQL scripts and queries used for analyzing pizza sales data. The primary focus is on optimizing queries to improve performance and efficiency.

## Overview

The `pizza_sales_data_analysis.sql` script includes several SQL queries for extracting and analyzing data related to pizza sales. One specific query focuses on retrieving the name and price of the most expensive pizza available.

## Query Optimization

### Original Query

The original query is designed to find the name and price of the most expensive pizza by joining two tables, `pizza_types` and `pizzas`. The query is as follows:

```sql
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
    JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
```

### Optimized Query

To optimize the query, the following steps were taken:

1. **Indexing:** Created indexes on the columns involved in the join and sorting operations (`pizza_type_id` and `price`) to improve query performance.

2. **Aliasing:** Used table aliases to simplify the query and make it more readable.

3. **Efficient Ordering and Limiting:** Ensured the query only retrieves the top record by ordering by price in descending order and limiting the result to 1.

The optimized query is as follows:

```sql
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
```

### Indexing Strategy

To further enhance performance, the following indexes were recommended:

- **Index on `pizza_type_id` in both tables:**
  - `pizza_types` table: `CREATE INDEX idx_pizza_types_pizza_type_id ON pizza_types(pizza_type_id);`
  - `pizzas` table: `CREATE INDEX idx_pizzas_pizza_type_id ON pizzas(pizza_type_id);`

- **Index on `price` column in the `pizzas` table:**
  - `CREATE INDEX idx_pizzas_price ON pizzas(price);`

### Considerations

- **Database-Specific Optimizations:** The optimizations provided may vary depending on the SQL database system being used (e.g., MySQL, PostgreSQL, SQL Server). It is recommended to review the query execution plan using the specific database's tools to ensure optimal performance.

- **Data Integrity:** Before applying indexes and constraints, ensure that the data is clean, particularly for unique and non-null requirements in primary key columns.

## How to Use

1. **Setup Database:** Ensure the database is properly set up with the necessary tables (`pizza_types` and `pizzas`).

2. **Run SQL Script:** Execute the `pizza_sales_data_analysis.sql` script to create and populate the tables, and then run the optimized query.

3. **Review and Analyze:** Review the output for insights into the most expensive pizzas available.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For further inquiries or contributions, please contact [AJAY PRAJAPATI](mailto:ajayxd43@gmail.com).
