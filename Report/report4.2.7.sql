CREATE OR REPLACE PROCEDURE prc_food_item_report IS
    CURSOR csr_getfooditemreport IS
        SELECT
            fi.food_name,
            SUM(CASE WHEN TO_NUMBER(TO_CHAR(o.order_date, 'Q')) = 1 THEN oi.order_quantity * fi.food_price ELSE 0 END) AS q1_profit,
            SUM(CASE WHEN TO_NUMBER(TO_CHAR(o.order_date, 'Q')) = 2 THEN oi.order_quantity * fi.food_price ELSE 0 END) AS q2_profit,
            SUM(CASE WHEN TO_NUMBER(TO_CHAR(o.order_date, 'Q')) = 3 THEN oi.order_quantity * fi.food_price ELSE 0 END) AS q3_profit,
            SUM(CASE WHEN TO_NUMBER(TO_CHAR(o.order_date, 'Q')) = 4 THEN oi.order_quantity * fi.food_price ELSE 0 END) AS q4_profit,
            SUM(oi.order_quantity * fi.food_price) AS total_food_revenue
        FROM
            Orders o
            JOIN Order_Item oi ON o.order_id = oi.order_id
            JOIN Food_Item fi ON oi.food_id = fi.food_id
        WHERE
            TO_NUMBER(TO_CHAR(o.order_date, 'Q')) BETWEEN 1 AND 4
        GROUP BY
            fi.food_name
        ORDER BY
            fi.food_name;

    -- Variables to hold quarterly totals
    q1_total_profit NUMBER := 0;
    q2_total_profit NUMBER := 0;
    q3_total_profit NUMBER := 0;
    q4_total_profit NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE(LPAD('=', 144, '='));
    DBMS_OUTPUT.PUT_LINE('| ' || LPAD('Food Item Revenue & Profit Quarterly Report', 88, ' ') || LPAD(' | ', 55));
    DBMS_OUTPUT.PUT_LINE('| ' || RPAD(' ', 140) || ' | ');
    DBMS_OUTPUT.PUT_LINE('| ' || LPAD('Report Generated:', 117, ' ') ||
        TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || '    |');
    DBMS_OUTPUT.PUT_LINE(LPAD('-', 144, '-'));

    -- Header
    DBMS_OUTPUT.PUT_LINE('| ' || RPAD('Food Item', 20) || ' | ' ||
        RPAD('Q1 Profit (USD)', 20) || ' | ' ||
        RPAD('Q2 Profit (USD)', 20) || ' | ' ||
        RPAD('Q3 Profit (USD)', 20) || ' | ' ||
        RPAD('Q4 Profit (USD)', 20) || ' | ' ||
        RPAD('Total Food Revenue(USD)', 25) || ' | ');

    DBMS_OUTPUT.PUT_LINE(LPAD('-', 144, '-'));

    -- Loop through the cursor and display quarterly profits and total food revenue
    FOR food_item_rec IN csr_getfooditemreport LOOP
        DBMS_OUTPUT.PUT_LINE('| ' || LPAD(food_item_rec.food_name, 20) || ' | ' ||
            LPAD(TO_CHAR(food_item_rec.q1_profit, '999,999,999.99'), 20) || ' | ' ||
            LPAD(TO_CHAR(food_item_rec.q2_profit, '999,999,999.99'), 20) || ' | ' ||
            LPAD(TO_CHAR(food_item_rec.q3_profit, '999,999,999.99'), 20) || ' | ' ||
            LPAD(TO_CHAR(food_item_rec.q4_profit, '999,999,999.99'), 20) || ' | ' ||
            LPAD(TO_CHAR(food_item_rec.total_food_revenue, '999,999,999.99'), 25) || ' | ');

        -- Accumulate quarterly totals
        q1_total_profit := q1_total_profit + food_item_rec.q1_profit;
        q2_total_profit := q2_total_profit + food_item_rec.q2_profit;
        q3_total_profit := q3_total_profit + food_item_rec.q3_profit;
        q4_total_profit := q4_total_profit + food_item_rec.q4_profit;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(LPAD('-', 144, '-'));

    -- Display quarterly total profit row
    DBMS_OUTPUT.PUT_LINE('| ' || LPAD('Quarterly Total Profit', 20) || ' | ' ||
        LPAD(TO_CHAR(q1_total_profit, '999,999,999.99'), 20) || ' | ' ||
        LPAD(TO_CHAR(q2_total_profit, '999,999,999.99'), 20) || ' | ' ||
        LPAD(TO_CHAR(q3_total_profit, '999,999,999.99'), 20) || ' | ' ||
        LPAD(TO_CHAR(q4_total_profit, '999,999,999.99'), 20) || ' | ' ||
        LPAD(' ', 25) || ' | ');

    -- End of report
    DBMS_OUTPUT.PUT_LINE(LPAD('-', 144, '-'));
    DBMS_OUTPUT.PUT_LINE('| ' || LPAD('End Of Report', 76, ' ') || LPAD(' | ', 67));
    DBMS_OUTPUT.PUT_LINE(LPAD('-', 144, '-'));

END;
/
