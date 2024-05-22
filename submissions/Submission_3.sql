-- DBMS Submission - 3 ( 12/02/2024 )



-- // Team Members:
-- Debjit Banerji (2022146)         Ashish Bargoti (2022114)       Kartikeya Sehgal (2022244)



-- // Commands to Create Tables:-

CREATE DATABASE croma_online;
USE croma_online;

CREATE TABLE customer (
  Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
  First_Name VARCHAR(255) NOT NULL,
  Middle_Name VARCHAR(255),
  Last_Name VARCHAR(255) NOT NULL,
  Email_ID VARCHAR(255) UNIQUE NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Contact_Number VARCHAR(20) UNIQUE NOT NULL,
  Payment_Mode VARCHAR(50) NOT NULL
);

CREATE TABLE addresses (
  Customer_ID INT NOT NULL,
  House_No VARCHAR(10) NOT NULL,
  Street VARCHAR(255) NOT NULL,
  Area VARCHAR(255) NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL,
  Pincode INT NOT NULL,
  Contact_Number VARCHAR(20),
  PRIMARY KEY (Customer_ID, House_No, Street),
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID)
);

CREATE TABLE products (
  Product_ID INT PRIMARY KEY auto_increment,
  Name VARCHAR(255) NOT NULL,
  Category1 VARCHAR(50) NOT NULL,
  Category2 VARCHAR(50),
  Category3 VARCHAR(50), 
  Brand_Name VARCHAR(100) NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  Description TEXT NOT NULL
);

CREATE TABLE cart (
  Customer_ID INT NOT NULL,
  Product_ID INT NOT NULL, 
  Quantity INT NOT NULL,
  Total_Price DECIMAL(10,2) NOT NULL,
  Added_Date DATE,
  PRIMARY KEY (Customer_ID, Product_ID),
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE delivery_agents (
  Agent_ID INT PRIMARY KEY auto_increment,
  Name VARCHAR(255) NOT NULL,
  Contact_No VARCHAR(20) NOT NULL,
  Contract_Start_Date date DEFAULT NULL,
  Contract_End_Date date DEFAULT NULL,
  Description TEXT NOT NULL,
  Service_Type VARCHAR(100) NOT NULL  
);

CREATE TABLE warehouses (
  Warehouse_ID INT PRIMARY KEY auto_increment,
  Name VARCHAR(255) NOT NULL,
  Contact_No VARCHAR(20) NOT NULL,
  Area VARCHAR(255) NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL,
  Country VARCHAR(50) NOT NULL,
  Pincode INT NOT NULL,
  Operation_Start_Date date DEFAULT NULL
);

CREATE TABLE suppliers (
  Supplier_ID INT PRIMARY KEY auto_increment,
  Name VARCHAR(255) NOT NULL,
  Email_ID VARCHAR(255) UNIQUE NOT NULL,
  Contact_No VARCHAR(20) UNIQUE NOT NULL,
  Description TEXT NOT NULL,
  Contract_Start_Date date DEFAULT NULL,
  Contract_End_Date date DEFAULT NULL
);  

CREATE TABLE inventory (
  Product_ID INT NOT NULL,
  Warehouse_ID INT NOT NULL, 
  Quantity INT NOT NULL,
  Last_Supply_Date DATE NOT NULL, 
  Supplier_ID INT NOT NULL,
  PRIMARY KEY (Product_ID, Warehouse_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
  FOREIGN KEY (Warehouse_ID) REFERENCES warehouses(Warehouse_ID),
  FOREIGN KEY (Supplier_ID) REFERENCES suppliers(Supplier_ID)
);

CREATE TABLE orders (
  Order_ID INT PRIMARY KEY,
  Customer_ID INT NOT NULL,
  Order_Placement_Date DATE,
  Discount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID)
);

CREATE TABLE order_products (
  Order_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Quantity INT NOT NULL,
  PRIMARY KEY (Order_ID, Product_ID),
  FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE procurement (
  Procurement_Order_ID INT PRIMARY KEY auto_increment,
  Warehouse_ID INT,
  Supplier_ID INT,
  Product_ID INT,
  Quantity INT NOT NULL,
  Date_Of_Purchase DATE,
  foreign key (Warehouse_ID) references Warehouses(Warehouse_ID),
  FOREIGN KEY (Supplier_ID) REFERENCES suppliers(Supplier_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE shipments (
  Shipment_ID INT AUTO_INCREMENT primary key,
  Procurement_Order_ID INT NOT NULL,
  Delivery_Agent_ID INT DEFAULT NULL,
  Mfg_Date DATE,
  Shipment_Date DATE NOT NULL,
  Delivery_Date DATE DEFAULT NULL,
  FOREIGN KEY (Delivery_Agent_ID) REFERENCES delivery_agents(Agent_ID),
  foreign key (Procurement_Order_ID) references procurement(Procurement_Order_ID)
);

CREATE TABLE purchase_orders (
  Purchase_Order_ID INT primary key auto_increment,
  Procurement_Order_ID INT NOT NULL,
  Payment_Mode VARCHAR(50) NOT NULL,
  Total_Payable_Amount Decimal(10,2) NOT NULL,
  Payment_Status VARCHAR(25) NOT NULL DEFAULT 'Pending',
  Payment_Date DATE DEFAULT NULL,
  Payment_Time TIME DEFAULT NULL,
  foreign key (Procurement_Order_ID) references procurement(Procurement_Order_ID)
);

CREATE TABLE product_returns (
  Return_ID INT PRIMARY KEY,
  Product_ID INT NOT NULL,
  Customer_ID INT NOT NULL,
  Return_Date DATE NOT NULL,
  Return_Status VARCHAR(50) NOT NULL DEFAULT 'Pending',
  Order_ID INT NOT NULL,
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
  FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID)
);

CREATE TABLE product_reviews (
  Review_ID INT PRIMARY KEY,
  Customer_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Rating INT NOT NULL,
  Review TEXT NOT NULL,
  Review_Date DATE,
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE supplied_by (
  Supplier_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Shipment_ID INT NOT NULL,
  Quantity INT NOT NULL,
  PRIMARY KEY (Supplier_ID, Product_ID, Shipment_ID),
  foreign key (Shipment_ID) references shipments(Shipment_ID),
  FOREIGN KEY (Supplier_ID) REFERENCES suppliers(Supplier_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE supplies (
  Supplier_ID INT,
  Product_ID INT,
  PRIMARY KEY (Supplier_ID, Product_ID),
  FOREIGN KEY (Supplier_ID) REFERENCES suppliers(Supplier_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE transactions (
  Transaction_ID INT PRIMARY KEY auto_increment,
  Order_ID INT NOT NULL UNIQUE,
  Payment_Mode VARCHAR(50) NOT NULL,
  Payment_Status VARCHAR(50) NOT NULL, 
  Amount_Paid DECIMAL(10,0) NOT NULL,
  Transaction_Time TIMESTAMP,
  Transaction_Date DATE,
  FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID)
);

CREATE TABLE wishlist (
  Customer_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Added_Date DATE, 
  FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE delivery_details (
  Tracking_ID INT PRIMARY KEY AUTO_INCREMENT,
  Order_ID INT NOT NULL UNIQUE,
  Delivery_Agent_ID INT NOT NULL,
  Dispatch_Date DATE,
  Delivery_Status VARCHAR(50) DEFAULT 'Pending',
  FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID),
  FOREIGN KEY (Delivery_Agent_ID) REFERENCES delivery_agents(Agent_ID)
);

CREATE TABLE Shipment_Delivery (
  Shipment_ID INT NOT NULL,
  Warehouse_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Quantity_Received INT NOT NULL,
  Received_Date DATE,
  PRIMARY KEY (Shipment_ID, Warehouse_ID, Product_ID),
  FOREIGN KEY (Shipment_ID) REFERENCES shipments(Shipment_ID),
  FOREIGN KEY (Warehouse_ID) REFERENCES warehouses(Warehouse_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE Shipment_Order (
  Shipment_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Quantity_Shipped INT NOT NULL,
  PRIMARY KEY (Shipment_ID, Product_ID),
  FOREIGN KEY (Shipment_ID) REFERENCES shipments(Shipment_ID),
  FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);



-- // Commands to Insert Sample Data into the Tables:-

INSERT INTO customer (Customer_ID, First_Name, Middle_Name, Last_Name, Email_ID, Password, Contact_Number, Payment_Mode) 
VALUES
(1, 'Rajesh', 'Kumar', 'Sharma', 'rajesh.sharma@example.com', 'password123', '9876543210', 'Credit Card'),
(2, 'Priya', 'Singh', 'Patel', 'priya.patel@example.com', 'password456', '1234567890', 'PayPal'),
(3, 'Amit', NULL, 'Verma', 'amit.verma@example.com', 'password789', '9876123450', 'Debit Card'),
(4, 'Sneha', 'Rani', 'Gupta', 'sneha.gupta@example.com', 'passwordabc', '9988776655', 'Cash'),
(5, 'Neha', 'Kumari', 'Jha', 'neha.jha@example.com', 'passwordxyz', '7755889966', 'Credit Card'),
(6, 'Vikas', NULL, 'Yadav', 'vikas.yadav@example.com', 'password1234', '6655443322', 'PayPal'),
(7, 'Shreya', 'Singh', 'Sharma', 'shreya.sharma@example.com', 'password5678', '9876541235', 'Debit Card'),
(8, 'Rohit', 'Kumar', 'Gupta', 'rohit.gupta@example.com', 'password9012', '9988778655', 'Cash'),
(9, 'Pooja', NULL, 'Mishra', 'pooja.mishra@example.com', 'password3456', '7755889066', 'Credit Card'),
(10, 'Anuj', 'Singh', 'Verma', 'anuj.verma@example.com', 'password7890', '6655403322', 'PayPal');

INSERT INTO addresses (Customer_ID, House_No, Street, Area, City, State, Pincode, Contact_Number) VALUES  
(1, 'B-201', 'Main Street', 'Sector 15', 'Noida', 'Uttar Pradesh', 201301, '1234567890'),
(2, 'A-402', 'Park Avenue', 'Sector 63', 'Noida', 'Uttar Pradesh', 201302, '0987654321' ),
(3, '13', 'High Street', 'Sector 31', 'Gurgaon', 'Haryana', 122001, '1112223333'), 
(4, '306', 'Central Street', 'Sector 15', 'Chandigarh', 'Punjab', 160031, '4445556666'),
(5, 'P-7', 'Broadway', 'Sector 12', 'Kolkata', 'West Bengal', 700014, '7777888999'),
(6, '45', 'Main Road', 'Banaswadi', 'Bangalore', 'Karnataka', 560043, '333111222'),  
(7, 'A-45', 'MG Road', 'Vasant Vihar', 'New Delhi', 'New Delhi', 110057, '5556667777'),
(8, '23', 'Church Street', 'Indiranagar', 'Bangalore', 'Karnataka', 560038, '9990008888'), 
(9, '15', 'Park Street', 'Salt Lake', 'Kolkata', 'West Bengal', 700064, '1231231234'),
(10, '402', 'Nehru Street', 'Dwarka', 'New Delhi', 'New Delhi', 110075, '3213213213');

INSERT INTO products (Name, Category1, Category2, Category3, Brand_Name, Price, Description) VALUES  
('iPhone 14', 'Mobiles', 'Smartphones', NULL, 'Apple', 89900.00, 'Latest iPhone model'),
('OnePlus 10T', 'Mobiles','Smartphones', NULL, 'OnePlus', 54999.00, 'Flagship OnePlus smartphone'),  
('Fire TV Stick', 'Electronics', 'Streaming Devices', NULL, 'Amazon', 3499.00, 'Streaming device by Amazon'),
('Boat Rockerz 335', 'Electronics', 'Headphones', 'Wireless', 'Boat', 1299.00, 'Wireless Bluetooth headphones'), 
('Mi Robot Vacuum', 'Appliances', 'Vacuum Cleaners', NULL, 'Xiaomi', 21999.00, 'Robot vacuum cleaner'),  
('IFB Washing Machine','Appliances', 'Washing Machines', NULL, 'IFB', 29999.00, 'Fully automatic washing machine'),
('Nike Air Shoes', 'Fashion', 'Shoes', 'Sports', 'Nike', 7999.00, 'Running and workout shoes'),
('Puma Tshirt ', 'Fashion', 'Clothing', 'Tshirts','Puma', 1299.00, 'Men''s round neck tshirt'),
('HP 15 Laptop','Electronics', 'Laptops', NULL, 'HP',41999.00, '15 inch screen laptop'), 
('Boat Airdopes 131', 'Electronics', 'Headphones', 'TWS Earbuds', 'Boat', 1299.00, 'Wireless bluetooth earbuds');

INSERT INTO cart (Customer_ID, Product_ID, Quantity, Total_Price, Added_Date) VALUES
(1, 1, 1, 89900.00, '2023-02-10'),  
(3, 3, 2, 6998.00, '2023-02-11'),
(5, 7, 1, 7999.00, '2023-02-09'),
(2, 2, 1, 54999.00, '2023-02-12'),  
(7, 9, 1, 41999.00, '2023-02-11'),
(9, 4, 2, 2598.00, '2023-02-10'),
(4, 5, 1, 21999.00, '2023-02-08'), 
(10, 8, 3, 3897.00, '2023-02-07'),
(8, 6, 1, 29999.00, '2023-02-06'),  
(6, 10, 2, 2598.00, '2023-02-05');

INSERT INTO delivery_agents (Agent_ID, Name, Contact_No, Description, Service_Type) 
VALUES
(1, 'Rahul Kumar', '1112423344', 'Fast and reliable delivery service', 'Express Delivery'),
(2, 'Rohan yadav', '5544667688', 'Specialized in handling electronic gadgets', 'Standard Delivery'),
(3, 'ramesh kumar', '9988976655', 'Swift delivery service for electronics', 'Same-day Delivery'),
(4, 'neel yadav', '2233245566', 'Delivering electronic products with care', 'Standard Delivery'),
(5, 'rakesh', '7788991011', 'Expert in handling fragile electronic items', 'Standard Delivery'),
(6, 'rakesh kumar', '3322210099', 'Efficient delivery service for digital products', 'Standard Delivery'),
(7, 'vipul verma', '4455664788', 'Express delivery for electronic items', 'Express Delivery'),
(8, 'guru', '5566778849', 'Reliable transportation service for tech products', 'Standard Delivery'),
(9, 'gajendra', '6677489900', 'Swift and safe delivery of electronic gadgets', 'Express Delivery'),
(10, 'ramesh kumar', '7788994011', 'Expert handling of delicate electronic devices during delivery', 'Standard Delivery');

INSERT INTO warehouses (Name, Contact_No, Area, City, State, Country, Pincode, Operation_Start_Date) VALUES
('ABC Warehouses', '01112345678', 'Sector 63', 'Noida', 'Uttar Pradesh', 'India', 201304, '2017-01-01'),  
('XYZ Storage', '01198765432', 'Banaswadi', 'Bangalore', 'Karnataka', 'India', 560043, '2018-04-01'),
('Prime Warehouse', '02233445566', 'Dwarka', 'New Delhi', 'New Delhi', 'India', 110075, '2020-07-15'),   
('Secure Storage', '03388991122', 'Salt Lake', 'Kolkata', 'West Bengal', 'India', 700064, '2019-02-01'),  
('Smart Warehouse', '04498765321', 'Bommanahalli', 'Bangalore', 'Karnataka', 'India', 560068, '2016-11-01'),
('Modern Warehouses', '05512345321', 'Sector 31', 'Gurgaon', 'Haryana','India', 122001, '2015-06-01'),
('StoreNPack', '06634512789', 'Vasant Kunj', 'New Delhi', 'New Delhi','India', 110070, '2022-03-01'),
('Safe Storage', '07722446688', 'Kalamboli', 'Mumbai', 'Maharashtra','India', 410218, '2021-05-01'), 
('Mega Warehouse', '08811122233', 'Sector 5', 'Manesar', 'Haryana', 'India', 122050, '2017-07-01'),
('BoxHub', '09988776655', 'Whitefield', 'Bangalore', 'Karnataka', 'India', 560066, '2020-01-15');

INSERT INTO suppliers (Name, Email_ID, Contact_No, Description, Contract_Start_Date, Contract_End_Date) VALUES 
('ABC Supplies', 'abc@example.com','01112345678', 'Leading supplier', '2022-01-01', '2024-12-31'),
('XYZ Distributors', 'xyz@example.com','01198765432', 'Reliable distributor','2021-01-01', NULL),
('Prime Products','prime@example.com','02233445566', 'Bulk supplier', '2023-01-01', NULL), 
('Max Wholesale', 'max@example.com','03388991122', 'Wholesale supplier', '2022-07-01', NULL),
('Swift Suppliers', 'swift@example.com','04498765321','Just-in-time supplier', '2020-01-01', NULL),  
('Shopsy', 'shopsy@example.com','05576849302','Marketplace for suppliers', '2022-04-01', NULL ),
('Kibo Commerce', 'kibo@example.com','06634512789','Dropshipping supplier', '2021-01-01', NULL), 
('Zest Supplies', 'zest@example.com','07722446688','Startup supplier', '2019-01-01', NULL),  
('Ace Distributors', 'ace@example.com', '08811122233','B2B distributors', '2021-05-01', NULL),
('Uni Suppliers', 'uni@example.com','09988776655','Unique products supplier', '2020-07-01', NULL);
                
INSERT INTO inventory (Product_ID, Warehouse_ID, Quantity, Last_Supply_Date, Supplier_ID) VALUES  
(1, 1, 100, '2023-02-10', 1),  
(2, 2, 50, '2023-02-12', 2),
(3, 3, 300, '2023-02-11', 3),
(4, 4, 200, '2023-02-09', 4), 
(5, 5, 100, '2023-02-08', 5),
(6, 6, 150, '2023-02-15', 6),  
(7, 7, 100, '2023-02-13', 7),  
(8, 8, 400, '2023-02-20', 8),
(9, 9, 200, '2023-02-17', 9),
(10, 10, 500, '2023-02-22', 10);

INSERT INTO orders (Order_ID, Customer_ID, Order_Placement_Date, Discount) VALUES
(1001, 1, '2023-02-14', 1000.00),  
(1002, 3, '2023-02-15', 500.00),
(1003, 5, '2023-02-16', 0), 
(1004, 2, '2023-02-17', 800.00),
(1005, 7, '2023-02-18', 1500.00),
(1006, 9, '2023-02-19', 700.00),  
(1007, 4, '2023-02-12', 2000.00),
(1008, 10, '2023-02-23', 250.00),  
(1009, 8, '2023-02-26', 0),
(1010, 6, '2023-02-28', 1200.00);

INSERT INTO order_products (Order_ID, Product_ID, Quantity) VALUES 
(1001, 1, 1),
(1002, 3, 2),
(1003, 7, 1),
(1004, 2, 1),  
(1005, 9, 1), 
(1006, 4, 2),
(1007, 5, 1),
(1008, 8, 3),
(1009, 6, 1),
(1010, 10, 2);

INSERT INTO product_reviews (Review_ID, Customer_ID, Product_ID, Rating, Review, Review_Date) VALUES 
(1, 1, 1, 5, 'Excellent phone with great camera and display', '2023-02-15'),
(2, 2, 2, 4, 'Very good performance but battery life could be better', '2023-02-18'),
(3, 3, 3, 5, 'Easy to setup and use streaming device', '2023-02-20'),  
(4, 5, 7, 3, 'Shoes are comfortable but not very durable', '2023-02-22'),
(5, 9, 4, 5, 'Clear sound quality, comfortable for long duration use','2023-02-24'),
(6, 10, 8, 4, 'Good quality tshirt with nice fit', '2023-02-26'),
(7, 6, 5, 5, 'Excellent phone with great camera and display', '2023-02-15'),
(8, 2, 2, 4, 'Very good performance but battery life could be better', '2023-02-18'),
(9, 3, 3, 5, 'Easy to setup and use streaming device', '2023-02-20'),  
(10, 5, 7, 3, 'Shoes are comfortable but not very durable', '2023-02-22');

INSERT INTO wishlist (Customer_ID, Product_ID, Added_Date) VALUES
(3, 5, '2023-02-14'), 
(7, 2, '2023-02-16'),
(4, 9, '2023-02-19'),
(8, 1, '2023-02-21'),
(6, 10, '2023-02-23'),
(3, 7, '2023-02-14'), 
(7, 3, '2023-02-16'),
(4, 6, '2023-02-19'),
(8, 2, '2023-02-21'),
(6, 8, '2023-02-23');

INSERT INTO transactions (Transaction_ID, Order_ID, Payment_Mode, Payment_Status, Amount_Paid, Transaction_Date) VALUES  
(101, 1001, 'Credit Card', 'Complete', 89900, '2023-02-15'),
(102, 1002, 'Debit Card', 'Failed', 6998, '2023-02-18' ),  
(103, 1003, 'PayPal', 'Complete', 7999, '2023-02-20'),
(104, 1005, 'Credit Card', 'Complete', 33999, '2023-02-22'),
(105, 1007, 'Cash', 'Complete', 19999, '2023-02-25'),
(106, 1004, 'Credit Card', 'Complete', 89900, '2023-02-15'),
(107, 1006, 'Debit Card', 'Failed', 6998, '2023-02-18' ),  
(108, 1008, 'PayPal', 'Complete', 7999, '2023-02-20'),
(109, 1009, 'Credit Card', 'Complete', 33999, '2023-02-22'),
(110, 1010, 'Cash', 'Complete', 19999, '2023-02-25');

INSERT INTO delivery_details (Tracking_ID, Order_ID, Delivery_Agent_ID, Dispatch_Date) VALUES
(501, 1001, 1, '2023-02-16'),  
(502, 1002, 2, '2023-02-20'), 
(503, 1004, 3, '2023-02-23'),
(504, 1006, 4, '2023-02-28'),
(505, 1010, 5, '2023-03-03'),
(506, 1003, 1, '2023-02-16'),  
(507, 1005, 2, '2023-02-20'), 
(508, 1007, 3, '2023-02-23'),
(509, 1008, 4, '2023-02-28'),
(510, 1009, 5, '2023-03-03');

INSERT INTO procurement (Procurement_Order_ID, Warehouse_ID, Supplier_ID, Product_ID, Quantity, Date_Of_Purchase) VALUES  
(1, 1, 1, 1, 100, '2023-02-10'),
(2, 2, 2, 2, 50, '2023-02-11'),
(3, 3, 3, 3, 300, '2023-02-15'), 
(4, 4, 4, 4, 200, '2023-02-18'),
(5, 5, 5, 5, 100, '2023-02-20'),
(6, 1, 1, 7, 100, '2023-02-22'),
(7, 2, 2, 8, 400, '2023-02-24'),  
(8, 3, 3, 9, 200, '2023-02-26'),
(9, 4, 4, 10, 500, '2023-02-28'),
(10, 5, 5, 6, 150, '2023-03-02');

INSERT INTO shipments (Shipment_ID, Procurement_Order_ID, Delivery_Agent_ID, Mfg_Date, Shipment_Date) VALUES 
(1, 1, 1, '2023-02-05', '2023-02-12'), 
(2, 2, 2, '2023-02-07', '2023-02-15'),
(3, 3, 3, '2023-02-10', '2023-02-18'), 
(4, 4, 4, '2023-02-11', '2023-02-20'),
(5, 5, 5, '2023-02-15', '2023-02-22'),  
(6, 6, 1, '2023-02-16', '2023-02-24'),
(7, 7, 2, '2023-02-20', '2023-02-26'),
(8, 8, 3, '2023-02-25', '2023-02-28'),
(9, 9, 4, '2023-02-27', '2023-03-02'),
(10, 10, 5, '2023-03-01', '2023-03-04');

INSERT INTO purchase_orders (Purchase_Order_ID, Procurement_Order_ID, Payment_Mode, Total_Payable_Amount ) VALUES
(501, 1, 'Bank Transfer', 9000000),  
(502, 2, 'Credit Card', 2750000),
(503, 3, 'Debit Card', 10500000),  
(504, 4, 'UPI', 7000000),
(505, 5, 'Bank Transfer', 5500000),
(506, 6, 'Credit Card', 6000000), 
(507, 7, 'Debit Card', 10000000),
(508, 8, 'UPI', 7500000),  
(509, 9, 'Bank Transfer', 9500000),
(510, 10, 'Credit Card', 6500000);

INSERT INTO product_returns(Return_ID, Product_ID, Customer_ID, Return_Date, Order_ID ) VALUES  
(101, 1, 1, '2023-02-18', 1001),  
(102, 2, 2, '2023-02-22', 1004), 
(103, 4, 6, '2023-02-26', 1006),
(104, 5, 10, '2023-02-28', 1010),
(105, 7, 5, '2023-03-02', 1003),
(106, 8, 8, '2023-03-05', 1009),
(107, 9, 7, '2023-03-08', 1005),  
(108, 10, 3, '2023-03-11', 1002),
(109, 3, 9, '2023-03-15', 1006),
(110, 6, 4, '2023-03-18', 1007);

INSERT INTO supplied_by(Supplier_ID, Product_ID,Shipment_ID, Quantity) VALUES
(1, 1, 1, 50),  
(2, 2, 2, 25), 
(3, 3, 3, 100),
(4, 4, 4, 100),
(5, 5, 5, 50), 
(1, 7, 6, 50),  
(2, 8, 7, 200),
(3, 9, 8, 50),
(4, 10,9, 200),
(5, 6, 10, 80);

INSERT INTO supplies(Supplier_ID, Product_ID) VALUES  
(1,1),
(2,2),  
(3,3),
(4,4),
(5,5),  
(1,7),
(2,8),
(3,9),  
(4,10), 
(5,6);

INSERT INTO Shipment_Delivery (Shipment_ID, Warehouse_ID, Product_ID, Quantity_Received, Received_Date) 
VALUES  
(1, 1, 1, 100, '2023-02-15'),
(2, 2, 2, 50, '2023-02-18'),  
(3, 3, 3, 200, '2023-02-20'),
(4, 4, 4, 150, '2023-02-22'),
(5, 5, 5, 80, '2023-02-24'),
(6, 6, 6, 120, '2023-02-26'),
(7, 1, 7, 90, '2023-02-28'),
(8, 2, 8, 250, '2023-03-02'),
(9, 3, 9, 100, '2023-03-05'),
(10, 4, 10, 350, '2023-03-10');

INSERT INTO Shipment_Order (Shipment_ID, Product_ID, Quantity_Shipped)
VALUES  
(1, 1, 50), 
(2, 2, 25),
(3, 3, 100),  
(4, 4, 100),  
(5, 5, 50),
(6, 6, 80),
(7, 7, 50),   
(8, 8, 200),
(9, 9, 50),
(10, 10, 200);


