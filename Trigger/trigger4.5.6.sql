CREATE SEQUENCE Food_Price_History_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE TABLE Food_Price_History (
    history_id NUMBER DEFAULT Food_Price_History_Seq.NEXTVAL PRIMARY KEY,
    food_id NUMBER NOT NULL,
    old_price NUMBER(9,2) NOT NULL,
    new_price NUMBER(9,2) NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_type VARCHAR2(10),
    changed_by VARCHAR2(100) DEFAULT USER, -- Capturing the DB user. You might have another mechanism in place to get this.
    CONSTRAINT FK_food_price_history_food FOREIGN KEY (food_id)
        REFERENCES Food_Item(food_id)
);

CREATE OR REPLACE TRIGGER Price_Change_Audit_Trigger
AFTER INSERT OR DELETE OR UPDATE OF food_price ON Food_Item
FOR EACH ROW
DECLARE
    v_old_price NUMBER(9,2);
    v_new_price NUMBER(9,2);
    v_change_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_old_price := NULL;
        v_new_price := :NEW.food_price;
        v_change_type := 'INSERT';
    ELSIF DELETING THEN
        v_old_price := :OLD.food_price;
        v_new_price := NULL;
        v_change_type := 'DELETE';
    ELSE
        v_old_price := :OLD.food_price;
        v_new_price := :NEW.food_price;
        v_change_type := 'UPDATE';
    END IF;

    INSERT INTO Food_Price_History (food_id, old_price, new_price, change_date, change_type)
    VALUES (:OLD.food_id, v_old_price, v_new_price, SYSTIMESTAMP, v_change_type);
END;
/
