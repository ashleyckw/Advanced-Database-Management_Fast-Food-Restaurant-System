SET LINESIZE 120

CREATE OR REPLACE PROCEDURE MonthlySalesComparison AS
  CURSOR sales_cursor IS
    SELECT
      TO_CHAR(o.order_date, 'YYYY-MM') AS order_month,
      c.country_name AS country_name,
      SUM(1) AS total_orders,
      SUM(p.payment_amount) AS total_sales
    FROM
      Orders o
      JOIN Customers cu ON o.customer_id = cu.customer_id
      JOIN Address a ON cu.customer_id = a.customer_id
      JOIN Countries c ON a.country_id = c.country_id
      LEFT JOIN Payment p ON o.order_id = p.order_id
    WHERE
      EXTRACT(YEAR FROM o.order_date) = EXTRACT(YEAR FROM SYSDATE) -- Current Year
      OR EXTRACT(YEAR FROM o.order_date) = EXTRACT(YEAR FROM SYSDATE) - 1 -- Previous Year
    GROUP BY
      TO_CHAR(o.order_date, 'YYYY-MM'),
      c.country_name
    ORDER BY
      TO_CHAR(o.order_date, 'YYYY-MM'),
      c.country_name;

  v_order_month VARCHAR2(7);
  v_country_name VARCHAR2(40);
  v_total_orders NUMBER;
  v_total_sales NUMBER;
  v_prev_year_orders NUMBER := 0; -- Initialize to 0 for the first iteration
  v_prev_year_sales NUMBER := 0;  -- Initialize to 0 for the first iteration

BEGIN
  -- Set the title
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 200, '=') );
  DBMS_OUTPUT.PUT_LINE('| ' || LPAD('Monthly Sales Comparison Report', 118, ' ') || LPAD(' | ', 81));
  DBMS_OUTPUT.PUT_LINE('| ' || RPAD(' ', 196) || ' | ');
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 200, '=') );

  OPEN sales_cursor;
 -- Header
  DBMS_OUTPUT.PUT_LINE(
    '| ' || RPAD('Month', 10) || ' | ' ||
    RPAD('Country', 25) || ' | ' ||
    LPAD('Orders (Current Year)', 25) || ' | ' ||
    LPAD('Orders (Previous Year)', 25) || ' | ' ||
    LPAD('Total Sales (Current Year)', 30) || ' | ' ||
    LPAD('Total Sales (Previous Year)', 30) || ' | ' ||
    LPAD('Difference', 15) || ' | ' ||
    LPAD('Status', 15) || ' | '
);

   DBMS_OUTPUT.PUT_LINE(LPAD('-', 200, '-'));

  LOOP
    FETCH sales_cursor INTO v_order_month, v_country_name, v_total_orders, v_total_sales;

    EXIT WHEN sales_cursor%NOTFOUND;

    IF v_order_month = TO_CHAR(SYSDATE, 'YYYY-MM') THEN
      -- Save the current year's data for the next iteration
      v_prev_year_orders := v_total_orders;
      v_prev_year_sales := v_total_sales;
    ELSE
      -- Calculate the difference and status compared to the previous year
      DECLARE
        v_difference NUMBER := v_total_orders - v_prev_year_orders;
        v_status VARCHAR2(10) := CASE
          WHEN v_difference > 0 THEN 'High'
          WHEN v_difference < 0 THEN 'Low'
          ELSE 'Same'
        END;
      BEGIN
       -- Output the data for the previous year
	DBMS_OUTPUT.PUT_LINE(
    	'| ' || LPAD(v_order_month, 10) || ' | ' ||
    	LPAD(v_country_name, 25) || ' | ' ||
    	LPAD(v_total_orders, 25) || ' | ' ||
    	LPAD(v_prev_year_orders, 25) || ' | ' ||
   	LPAD(v_total_sales, 30) || ' | ' ||
    	LPAD(v_prev_year_sales, 30) || ' | ' ||
    	LPAD(v_difference, 15) || ' | ' ||
    	LPAD(v_status, 15) || ' | '
	);

      END;
    END IF;
  END LOOP;

    DBMS_OUTPUT.PUT_LINE(LPAD('-', 200, '-'));
    DBMS_OUTPUT.PUT_LINE('| ' || LPAD('End Of Report', 109, ' ') || LPAD(' | ', 90));
    DBMS_OUTPUT.PUT_LINE(LPAD('-', 200, '-'));

  CLOSE sales_cursor;
END MonthlySalesComparison;
/

-- Execute the procedure
EXEC MonthlySalesComparison;
