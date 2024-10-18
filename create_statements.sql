---- CREATE SEQUENCE ------------------------------------------------------------------------------------
-- Create Sequence to insert into Regions Table
CREATE SEQUENCE region_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Restaurant_Location Table
CREATE SEQUENCE restaurant_location_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Restaurant_Branch Table
CREATE SEQUENCE restaurant_branch_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Stock_Item Table
CREATE SEQUENCE stock_item_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Supplier Table
CREATE SEQUENCE supplier_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Purchase_Order Table
CREATE SEQUENCE purchase_order_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Purchase_Item Table
CREATE SEQUENCE purchase_item_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Food_Menu Table
CREATE SEQUENCE food_menu_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Food_Category Table
CREATE SEQUENCE food_category_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Food_Item Table
CREATE SEQUENCE food_item_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Set_Meal Table
CREATE SEQUENCE set_meal_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Set_Item Table
CREATE SEQUENCE set_item_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Employees Table
CREATE SEQUENCE employees_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Customers Table
CREATE SEQUENCE customers_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Contacts Table
CREATE SEQUENCE contacts_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Address Table
CREATE SEQUENCE address_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Coupons Table
CREATE SEQUENCE coupons_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Orders Table
CREATE SEQUENCE orders_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Feedback Table
CREATE SEQUENCE feedback_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Order_Item Table
CREATE SEQUENCE order_item_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Payment Table
CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Cancellation Table
CREATE SEQUENCE cancellation_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Refund Table
CREATE SEQUENCE refund_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Create Sequence to insert into Delivery Table
CREATE SEQUENCE delivery_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


---- CREATE TABLE --------------------------------------------------------------------------------------
-- Create Regions Table
CREATE TABLE Regions (
    region_id NUMBER NOT NULL,
    region_name VARCHAR2(50) NOT NULL,
    PRIMARY KEY (region_id)
);

-- Create Countries Table
CREATE TABLE Countries (
    country_id CHAR(2) NOT NULL,
    country_name VARCHAR2(40) NOT NULL,
    region_id NUMBER,
    PRIMARY KEY (country_id),
    CONSTRAINT FK_countries_regions FOREIGN KEY(region_id)
        REFERENCES Regions(region_id)
);

-- Create Restaurant_Location Table
CREATE TABLE Restaurant_Location (
    location_id NUMBER NOT NULL,
    restaurant_address VARCHAR2(255) NOT NULL,
    restaurant_postal_code VARCHAR2(20) NOT NULL,
    restaurant_city VARCHAR2(50),
    restaurant_state VARCHAR2(50),
    country_id CHAR(2),
    PRIMARY KEY (location_id),
    CONSTRAINT FK_locations_countries FOREIGN KEY (country_id)
        REFERENCES Countries(country_id),
    CONSTRAINT CHK_rest_postal_code_format CHECK (REGEXP_LIKE(restaurant_postal_code, '^[0-9]{5}$'))
);

-- Create Restaurant_Branch Table
CREATE TABLE Restaurant_Branch (
    restaurant_id NUMBER NOT NULL,
    contact_number VARCHAR2(20) NOT NULL,
    opening_hour INTERVAL DAY TO SECOND,
    closing_hour INTERVAL DAY TO SECOND,
    location_id NUMBER,
    PRIMARY KEY (restaurant_id),
    CONSTRAINT FK_restaurant_location FOREIGN KEY (location_id)
        REFERENCES Restaurant_Location(location_id),
    CONSTRAINT CHK_rest_phone_format CHECK (REGEXP_LIKE(contact_number, '^\+\d{2} \d{3} \d{3} \d{4}$'))
);

-- Create Stock_Item Table
CREATE TABLE Stock_Item (
    stock_id NUMBER NOT NULL,
    stock_name VARCHAR2(255) NOT NULL,
    stock_quantity NUMBER DEFAULT 0,
    reorder_point NUMBER DEFAULT 20,
    last_stock_update DATE,
    restaurant_id NUMBER,
    PRIMARY KEY (stock_id),
    CONSTRAINT FK_stock_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES Restaurant_Branch(restaurant_id),
    CONSTRAINT CHK_stock_quantity CHECK (stock_quantity >= 0)
);

-- Create Supplier Table
CREATE TABLE Supplier (
    supplier_id NUMBER NOT NULL,
    supplier_name VARCHAR2(255) NOT NULL,
    supplier_contact VARCHAR2(20),
    PRIMARY KEY (supplier_id),
    CONSTRAINT CHK_supp_phone_format CHECK (REGEXP_LIKE(supplier_contact, '^\+\d{2} \d{3} \d{3} \d{4}$'))
);

-- Create Purchase_Order Table
CREATE TABLE Purchase_Order (
    purchase_order_id NUMBER NOT NULL,
    order_date DATE DEFAULT SYSDATE,
    delivery_date DATE DEFAULT SYSDATE,
    restaurant_id NUMBER,
    supplier_id NUMBER,
    PRIMARY KEY (purchase_order_id),
    CONSTRAINT FK_purchase_order_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES Restaurant_Branch(restaurant_id),
    CONSTRAINT FK_purchase_order_supplier FOREIGN KEY (supplier_id) 
        REFERENCES Supplier(supplier_id)
);

-- Create Purchase_Item Table
CREATE TABLE Purchase_Item (
    purchase_item_id NUMBER NOT NULL,
    quantity_ordered NUMBER NOT NULL,
    standard_cost NUMBER(8,2),
    purchase_order_id NUMBER,
    stock_id NUMBER,
    PRIMARY KEY (purchase_item_id),
    CONSTRAINT FK_purchase_item_order FOREIGN KEY (purchase_order_id)
        REFERENCES Purchase_Order(purchase_order_id),
    CONSTRAINT FK_purchase_item_stock FOREIGN KEY (stock_id)
        REFERENCES Stock_Item(stock_id)
);

-- Create Food_Menu Table
CREATE TABLE Food_Menu (
    menu_id NUMBER NOT NULL,
    menu_name VARCHAR2(255) NOT NULL,
    restaurant_id NUMBER,
    PRIMARY KEY (menu_id),
    CONSTRAINT FK_menu_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES Restaurant_Branch(restaurant_id)
);

-- Create Food_Category Table
CREATE TABLE Food_Category (
    category_id NUMBER NOT NULL,
    category_code VARCHAR2(50) NOT NULL,
    category_name VARCHAR2(255) NOT NULL,
    category_description VARCHAR2(2000),
    menu_id NUMBER,
    PRIMARY KEY (category_id),
    CONSTRAINT FK_food_category_menu FOREIGN KEY (menu_id)
        REFERENCES Food_Menu(menu_id)
);

-- Create Food_Item Table
CREATE TABLE Food_Item (
    food_id NUMBER NOT NULL,
    food_name VARCHAR2(255) NOT NULL,
    food_description VARCHAR2(2000),
    unit_price NUMBER(9,2) NOT NULL,
    food_price NUMBER(9,2) NOT NULL,
    category_id NUMBER,
    PRIMARY KEY (food_id),
    CONSTRAINT FK_food_item_category FOREIGN KEY (category_id)
        REFERENCES Food_Category(category_id),
    CONSTRAINT CHK_unit_price CHECK (unit_price >= 0),
    CONSTRAINT CHK_food_price CHECK (food_price >= 0)
);

-- Create Set_Meal Table
CREATE TABLE Set_Meal (
    meal_id NUMBER NOT NULL,
    meal_name VARCHAR2(50) NOT NULL,
    meal_price VARCHAR2(255) NOT NULL,
    meal_description VARCHAR2(2000),
    menu_id NUMBER,
    PRIMARY KEY (meal_id),
    CONSTRAINT FK_set_meal_menu FOREIGN KEY (menu_id)
        REFERENCES Food_Menu(menu_id)
);

-- Create Set_Item Table
CREATE TABLE Set_Item (
    set_item_id NUMBER NOT NULL,
    meal_id NUMBER,
    food_id NUMBER,
    PRIMARY KEY (set_item_id),
    CONSTRAINT FK_set_item_meal FOREIGN KEY (meal_id)
        REFERENCES Set_Meal(meal_id),
    CONSTRAINT FK_set_item_food FOREIGN KEY (food_id)
        REFERENCES Food_Item(food_id)
);

-- Create Employees Table
CREATE TABLE Employees (
    employee_id NUMBER NOT NULL,
    first_name VARCHAR2(255) NOT NULL,
    last_name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    phone VARCHAR2(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    hire_date DATE NOT NULL,
    manager_id NUMBER(12, 0),
    job_title VARCHAR2(255) NOT NULL,
    restaurant_id NUMBER,
    PRIMARY KEY (employee_id),
    CONSTRAINT FK_employees_manager FOREIGN KEY (manager_id)
        REFERENCES Employees(employee_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_employees_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES Restaurant_Branch(restaurant_id),
    CONSTRAINT CHK_emp_email_format CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
    CONSTRAINT CHK_emp_phone_format CHECK (REGEXP_LIKE(phone, '^\+\d{1,4} \d{3} \d{3} \d{4}$'))
);

-- Create Customers Table
CREATE TABLE Customers (
    customer_id NUMBER NOT NULL,
    first_name VARCHAR2(255) NOT NULL,
    last_name VARCHAR2(255),
    PRIMARY KEY (customer_id)
);

-- Create Contacts Table
CREATE TABLE Contacts (
    contact_id NUMBER NOT NULL,
    email VARCHAR2(255) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    customer_id NUMBER,
    PRIMARY KEY (contact_id),
    CONSTRAINT FK_contacts_customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT CHK_cust_phone_format CHECK (REGEXP_LIKE(phone, '^\+\d{1,4} \d{3} \d{3} \d{4}$'))
);

-- Create Address Table
CREATE TABLE Address (
    address_id NUMBER NOT NULL,
    street_line VARCHAR2(244) NOT NULL,
    postal_code VARCHAR2(20) NOT NULL,
    city VARCHAR2(20),
    state VARCHAR2(20) NOT NULL,
    country_id CHAR(2),
    customer_id NUMBER,
    PRIMARY KEY (address_id),
    CONSTRAINT FK_address_countries FOREIGN KEY (country_id)
        REFERENCES Countries(country_id),
    CONSTRAINT FK_address_customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT CHK_addr_postal_code_format CHECK (REGEXP_LIKE(postal_code, '^[0-9]{5}$'))
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id NUMBER NOT NULL,
    order_status VARCHAR2(20),
    order_date DATE DEFAULT SYSDATE,
    customer_id NUMBER,
    cashier_id NUMBER,
    PRIMARY KEY (order_id),
    CONSTRAINT FK_orders_employees FOREIGN KEY (cashier_id)
        REFERENCES Employees(employee_id)
        ON DELETE SET NULL,
    CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT CHK_order_status CHECK (order_status IN ('Ordered', 'Preparing', 'Delivering', 'Completed', 'Cancelled'))
);

-- Create Feedback Table
CREATE TABLE Feedback (
    feedback_id NUMBER NOT NULL,
    feedback_rating NUMBER(5),
    feedback_comment VARCHAR2(255),
    feedback_date DATE,
    order_id NUMBER,
    customer_id NUMBER,
    PRIMARY KEY (feedback_id),
    CONSTRAINT FK_feedback_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_feedback_customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT CHK_feedback_rating CHECK (feedback_rating >= 0 AND feedback_rating <= 5)
);

-- Create Order_Item Table
CREATE TABLE Order_Item (
    order_id NUMBER,
    order_item_id NUMBER,
    order_quantity NUMBER(4) NOT NULL,
    food_id NUMBER NOT NULL,
    CONSTRAINT PK_order_item PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT FK_order_item_orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_order_item_food FOREIGN KEY (food_id)
        REFERENCES Food_Item(food_id)
        ON DELETE CASCADE,
    CONSTRAINT CHK_order_quantity CHECK (order_quantity >= 0)
);

-- Create Coupons Table
CREATE TABLE Coupons (
    coupon_id NUMBER NOT NULL,
    coupon_code VARCHAR2(50) NOT NULL,
    coupon_name VARCHAR2(50),
    coupon_description VARCHAR2(250),
    coupon_discount NUMBER(8,2),
    coupon_type VARCHAR2(250),
    expiry_date DATE,
    order_id NUMBER,
    PRIMARY KEY (coupon_id),
    CONSTRAINT FK_coupon_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT CHK_coupon_type CHECK (coupon_type IN ('Percentage Off', 'Fixed Amount'))
);

-- Create Payment Table
CREATE TABLE Payment (
    payment_id NUMBER NOT NULL,
    payment_method VARCHAR2(50),
    payment_amount NUMBER(8,2),
    order_id NUMBER,
    PRIMARY KEY (payment_id),
    CONSTRAINT FK_payment_orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT CHK_payment_amount CHECK (payment_amount >= 0)
);

-- Create Cancellation Table
CREATE TABLE Cancellation (
    cancellation_id NUMBER NOT NULL,
    cancellation_date DATE DEFAULT SYSDATE,
    cancellation_reason VARCHAR2(50),
    order_id NUMBER,
    PRIMARY KEY (cancellation_id),
    CONSTRAINT FK_cancellation_orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

-- Create Refund Table
CREATE TABLE Refund (
    refund_id NUMBER NOT NULL,
    refund_amount NUMBER(8,2) NOT NULL,
    cancellation_id NUMBER,
    PRIMARY KEY (refund_id),
    CONSTRAINT FK_refund_cancellation FOREIGN KEY (cancellation_id)
        REFERENCES Cancellation(cancellation_id)
);

-- Create Delivery Table
CREATE TABLE Delivery (
    delivery_id NUMBER NOT NULL,
    delivery_date DATE DEFAULT SYSDATE,
    delivery_status VARCHAR2(50),
    delivery_distance NUMBER(8,2),
    order_id NUMBER,
    PRIMARY KEY (delivery_id),
    CONSTRAINT FK_delivery_orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT CHK_delivery_distance CHECK (delivery_distance >= 0)
);