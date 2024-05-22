-- Team Members:
-- Debjit Banerji (2022146)         Ashish Bargoti (2022114)       Kartikeya Sehgal (2022244)

-- PFA THE REALTIONAL SCHEMA

-- customer: (Customer_ID), First_Name, Middle_Name, Last_Name, Email_ID, Password, Contact_Number, Payment_Mode
-- addresses: (Customer_ID [FK], Address_Type, House_No), Street, Area, City, State, Pincode, Contact_Number
-- products: (Product_ID), Name, Category1, Category2, Category3, Brand_Name, Price, Description
-- cart: (Customer_ID [FK], Product_ID [FK]), Quantity, Total_Price, Added_Date
-- delivery_agents: (Agent_ID), Name, Contact_No, Contract_Start_Date, Contract_End_Date, Description, Service_Type
-- warehouses: (Warehouse_ID), Name, Contact_No, Area, City, State, Country, Pincode, Starting_Date
-- suppliers: (Supplier_ID), Name, Email_ID, Contact_No, Description, Contract_Start_Date, Contract_End_Date
-- inventory: (Product_ID [FK], Warehouse_ID [FK]), Quantity, Last_Supply_Date, Supplier_ID [FK]
-- orders: (Order_ID), Customer_ID [FK], Order_Placement_Date, Discount, address_type, house_no
-- OrderItems: (Order_ID [FK], Product_ID [FK]), Quantity
-- Restock_details: (Restock_ID), Warehouse_ID [FK], Supplier_ID [FK], Product_ID [FK], Quantity, Date_Of_Purchase
-- PURCHASE_ORDER: (Purchase_Order_ID), Payment_Mode, Total_Amount, Payment_Status, Payment_Date, Payment_Time
-- RESTOCK_PER_PO: (Purchase_Order_ID [FK], Restock_ID [FK])
-- shipments: (Shipment_ID), Mfg_Date, Purchase_Order_ID [FK], Shipment_Date, Delivery_Date
-- product_returns: (Return_ID), Product_ID [FK], Customer_ID [FK], Return_Date, Return_Status, Order_ID [FK]
-- product_reviews: (Review_ID), Customer_ID [FK], Product_ID [FK], Rating, Review, Review_Date
-- Shipment_Supplier_Index: (Supplier_ID [FK], Product_ID [FK], Shipment_ID [FK]), Quantity
-- Product_supplier: (Supplier_ID [FK], Product_ID [FK])
-- transactions: (Transaction_ID), Order_ID [FK], Payment_Mode, Payment_Status, Amount_Paid, Transaction_Time, Transaction_Date
-- wishlist: (Customer_ID [FK], Product_ID [FK], Added_Date)
-- delivery_details: (Order_ID [FK], Delivery_Agent_ID [FK]), Dispatch_Date, Delivery_Status
-- Shipment_Delivery: (Shipment_ID [FK], Warehouse_ID [FK], Product_ID [FK]), Quantity_Received, Received_Date

-- Query 1: calculate Amount paid in transaction for each order currently present in the TABLE
UPDATE TRANSACTIONS T
JOIN (
    SELECT T.Transaction_ID, T.Order_ID,(( items.Quantity * prod.Price ) - o.discount ) AS Amount_Paid
    FROM TRANSACTIONS T
    JOIN orders o ON T.Order_ID = o.Order_ID
    JOIN OrderItems items ON T.Order_ID = items.Order_ID
    JOIN products prod ON items.Product_ID = prod.Product_ID
) AS calculated_amount
ON T.Transaction_ID = calculated_amount.Transaction_ID
SET T.Amount_Paid = calculated_amount.Amount_Paid;
SELECT* FROM TRANSACTIONS;

-- Query 2: Get names of suppliers which supply atleast 2 products
SELECT NAME
FROM Suppliers Natural JOIN Product_supplier 
GROUP BY Supplier_ID 
HAVING COUNT(*) >= 2;

-- Query 3: Delete all products from Cart, where the quantity added for a product in a cart exceeds the quantity aviliable across all warehouses
DELETE C
FROM Cart C 
JOIN (
    SELECT inv.PRODUCT_ID,SUM( inv.QUANTITY ) AS stock
    FROM INVENTORY inv 
    GROUP BY inv.PRODUCT_ID 
    ) AS TOTAL
ON TOTAL.product_id = C.product_ID
WHERE stock < C.Quantity;


-- Query 4:  Number of orders delivered within distance <= 10 from 122003 pincode. distance = |Address.pincode - 122003 |
SELECT COUNT(*) 
AS NUMBER_OF_ORDERS_NEAR_122003
FROM ORDERS o Natural Join Addresses 
WHERE EXISTS (
    SELECT*
    FROM ADDRESSES Addr
    WHERE ( Addr.Customer_ID = o.Customer_ID ) AND ( Addr.ADDRESS_TYPE = o.ADDRESS_TYPE) AND
    ( ADDR.Pincode - 122003 ) BETWEEN -10 AND 10 
);

-- Query 5: Details of Customers which have placed the most number of orders along with the total amounts
SELECT cust.Customer_ID, CONCAT( cust.First_Name,' ',cust.Last_Name ) AS CUSTOMER_NAME,
COUNT( o.ORDER_ID ) AS ORDERS_PLACED,
SUM( T.Amount_Paid ) AS Total_Amount
FROM CUSTOMER cust
JOIN ORDERS o ON cust.Customer_ID = o.Customer_ID
JOIN TRANSACTIONS T on T.Order_ID = o.ORDER_ID
GROUP BY Customer_ID
HAVING ORDERS_PLACED > 1
ORDER BY Total_Amount DESC ;


-- Query 6: List all items in the wishlist for a customer given Customer ID '3'.
SELECT P.* FROM wishlist W, products P WHERE W.Customer_ID = 3 AND W.Product_ID = P.Product_ID;

-- Query 7: List the details of Shipments received by Warehouse 'C'
SELECT s.Shipment_ID,sd.Product_ID, p.Name AS Product_Name, 
sd.Quantity_Received, s.Shipment_Date, sd.received_date
FROM shipments s
JOIN Shipment_Delivery sd ON s.Shipment_ID = sd.Shipment_ID
JOIN products p ON sd.Product_ID = p.Product_ID
WHERE sd.Warehouse_ID = 3;

-- Query 8: List all ratings and reviews for a particular product (given Product: OnePlus10T Smartphone)
SELECT * FROM product_reviews P 
WHERE P.Product_ID = (
SELECT Product_ID FROM Products P1 WHERE P1.Name = 'OnePlus 10T' AND P1.Category1 = 'Mobiles' AND P1.Category2 = 'Smartphones'
);

-- Query 9: List all the previously purchased products for a customer (given Phone Number: '6655403322')
WITH product_ids(p_id,q) as (
SELECT Product_ID, SUM(OT.Quantity) FROM Orders O, OrderItems OT
WHERE O.Customer_ID = (SELECT Customer_ID FROM Customer C WHERE C.Contact_Number = '6655403322') AND
O.Order_ID = OT.Order_ID GROUP BY Product_ID
)
SELECT P1.*, P2.q AS Quantity FROM Products P1, product_ids P2 WHERE P1.Product_ID = P2.p_id;

-- Query 10: To Retrieve the average rating for each product
SELECT p.Product_ID, p.Name AS Product_Name, 
CAST(AVG(
        CASE WHEN pr.Rating IS NULL THEN -1 
        ELSE pr.Rating END
        ) AS SIGNED
    ) AS Average_Rating
FROM products p
LEFT JOIN product_reviews pr ON p.Product_ID = pr.Product_ID
GROUP BY p.Product_ID
ORDER BY p.Product_ID;


-- Queries to showcase constraints in our database ( These are bound to throw error )
-- Query 1: Adding a new address for customer with customer_id = 3 with invalid address type
INSERT INTO addresses (Customer_ID, Address_Type, House_No, Street, Area, City, State, Pincode, Contact_Number) VALUES  
(3, 'MyHouse','M43', 'High Street', 'Sector 15', 'Noida', 'Uttar Pradesh', 201301, '1112223333');

-- Query 2: Adding a new address for customer with customer_id = 3 with null as value of a primary key attribute
INSERT INTO addresses (Customer_ID, Address_Type, House_No, Street, Area, City, State, Pincode, Contact_Number) VALUES  
(3, 'Other',NULL, 'High Street', 'Sector 15', 'Noida', 'Uttar Pradesh', 201301, '1112223333');

-- Query 3: Delivery date of Shipment cannot be before shipment date
INSERT INTO shipments (Mfg_Date, Purchase_Order_ID, Shipment_Date, Delivery_Date) 
VALUES ('2023-01-15', 123, '2023-02-10', '2023-02-05');

-- Query 4: Manufacturing date has to be <= Shipment Date
INSERT INTO shipments (Mfg_Date, Purchase_Order_ID, Shipment_Date, Delivery_Date) 
VALUES ('2023-02-20', 456, '2023-02-10', '2023-02-15');

-- Query 5: Inserting a record which fails the foreign key constraints of the "Product_Reviews" table, since both these values do not have corresponding records in the tables "Customer" and "Products" respectively
INSERT INTO product_reviews VALUES(11,15,20,4,"Great product! It's worth it's cost!","2023-03-05");

-- TRIGGER to calculate Amount paid in transaction according to row inserted in ORDERS
DELIMITER //

CREATE TRIGGER set_total_amount
AFTER INSERT ON ORDERS
FOR EACH ROW
BEGIN
    DECLARE Amount DECIMAL(10,2);
    
    SELECT SUM(items.Quantity * prod.Price - NEW.discount ) INTO Amount
    FROM OrderItems items
    INNER JOIN Products prod ON items.Product_ID = prod.Product_ID
    WHERE items.Order_ID = NEW.Order_ID;

    UPDATE TRANSACTIONS T
    SET T.Amount_paid = Amount 
    WHERE order_id = NEW.order_id;
END;
//

DELIMITER ;

-- Contribution:
-- Each member wrote four queries each. Best 10 were selected.


-- SELECT inv.Warehouse_ID, SUM( inv.QUANTITY ) AS stock
-- FROM INVENTORY inv 
-- where inv.product_id = 1
-- GROUP BY Warehouse_ID
-- having AND Warehouse_ID IN ( 1, 2, 3 );

