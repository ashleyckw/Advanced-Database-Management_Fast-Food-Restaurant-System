# Advanced-Database-Management_Fast-Food-Restaurant-System
This project involves building a comprehensive Fast Food Restaurant System using Oracle and PL/SQL. It includes database design in 3rd Normal Form, ETL processes, advanced SQL queries, stored procedures, triggers, and report generation for decision-making. The system allows for efficient management of restaurant data, including inventory, employee performance, and customer orders.

## Key Features
* ER Diagram & 3NF Design: Complete database design with primary/foreign keys and relationships.
* ETL & Data Warehousing: Efficient ETL processes for data transformation and integration using PL/SQL.
* Stored Procedures & Triggers: Includes stored procedures and triggers to automate business processes and enforce rules.
* SQL Queries & Reports: Advanced queries for strategic, tactical, and operational decision-making, utilizing views and aggregate functions.
* Reports: Dynamic reports for analyzing sales, inventory, and employee performance with parameters passed and cursor usage.

## Technologies Used
* Oracle Database
* PL/SQL
* ERD (Entity Relationship Diagram)
* ETL (Extract, Transform, Load) Processes
* Stored Procedures
* Triggers
* SQL Query Optimization

## Files
* `create_statements.sql`: Contains SQL statements to create all tables in the system.
* `insert_statements.sql`: SQL script to insert initial sample data into the tables.
* `drop_statements.sql`: SQL script to drop all tables from the database.
* `examine_table_statement.sql`: Script to examine the structure and contents of the tables.
* **Procedure folder**: Contains stored procedures that implement various business processes.
* **Query folder**: Contains advanced multi-table queries for decision-making at strategic, tactical, and operational levels.
* **Report folder**: SQL scripts for generating detailed and summary reports using cursors and parameters.
* **Trigger folder**: Contains triggers enforcing business rules and system-wide policies.
* **Fast Food Restaurant System ERD - Final ERD.png**: The final entity-relationship diagram (ERD) showing the design of the database.

## Usage
1. **Run the Schema and Data Setup:**
   - Execute `create_statements.sql` to create all tables in the database.
   - Run `insert_statements.sql` to populate the tables with initial sample data.

2. **Examine the Database:**
   - Use `examine_table_statement.sql` to check the structure and contents of the tables.

3. **Run Procedures, Queries, Triggers, and Reports:**
   - Execute all SQL files from the `Procedure`, `Query`, `Report`, and `Trigger` folders in any order based on your use case:
     - **Procedures**: Automate business logic for tasks like adding new branches or managing customer accounts.
     - **Queries**: Generate insights from multi-table queries for decision-making at different management levels.
     - **Reports**: Generate detailed and summary reports using cursors with dynamic inputs.
     - **Triggers**: Enforce system-wide rules and policies, such as salary audits or purchase order tracking.

4. **Database Management:**
   - To reset the database, run `drop_statements.sql` to drop all tables.

## Project Impact
This project showcases the integration of database design and management with decision-making queries, stored procedures, and report generation. The system enhances operational efficiency, inventory management, and employee performance tracking, and provides valuable insights for strategic and tactical planning in a fast food restaurant setting.
