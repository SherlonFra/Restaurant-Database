USE master;

DROP DATABASE IF EXISTS RestaurantManager;
CREATE DATABASE RestaurantManager

USE RestaurantManager;
GO

--Schema Name for Restaurant System
CREATE SCHEMA Restaurant;
GO

--DROP TABLE IF EXISTS Restaurant.AreaCodeField;
--SELECT*FROM Restaurant.AreaCodeField
CREATE TABLE Restaurant.AreaCodeField
(
	AreaCode VARCHAR(10) PRIMARY KEY NOT NULL,
	AreaName VARCHAR(200) NOT NULL
);
GO
--DROP TABLE IF EXISTS Restaurant.DeliveryBoy
--SELECT*FROM Restaurant.DeliveryBoy
CREATE TABLE Restaurant.DeliveryBoy
(
	DeliveryBoyId INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	DeliveryAreaCode VARCHAR(10) NOT NULL REFERENCES Restaurant.AreaCodeField(AreaCode)
);
GO

--SELECT*FROM Restaurant.Customer
--DROP TABLE IF EXISTS Restaurant.Customer
CREATE TABLE Restaurant.Customer
(
	CustomerId INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TelephoneNumber VARCHAR(10) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	AreaCode VARCHAR(10) NOT NULL REFERENCES Restaurant.AreaCodeField(AreaCode),
	OrderLocation VARCHAR(1000) NOT NULL,
	CustomerStatus VARCHAR(10) NOT NULL,
	Discount INT NOT NULL
);
GO

--SELECT*FROM Restaurant.Payment
CREATE TABLE Restaurant.Payment
(
	PaymentId INT PRIMARY KEY NOT NULL,
	PaymentDate DATE NOT NULL,
	Amount DECIMAL (5,2) NOT NULL,
	PaymentType VARCHAR(20) NOT NULL
);
GO

CREATE INDEX idx_PaymentRestaurant
ON Restaurant.Payment(PaymentId, PaymentDate, Amount, PaymentType);
GO

--DROP TABLE IF EXISTS Restaurant.ToOrder
--SELECT*FROM Restaurant.ToOrder
CREATE TABLE Restaurant.ToOrder
(
	OrderId INT PRIMARY KEY NOT NULL,
    CustomerId INT NOT NULL REFERENCES Restaurant.Customer (CustomerId),
	PaymentId INT NOT NULL REFERENCES Restaurant.Payment(PaymentId)
);
GO

--SELECT*FROM Restaurant.Menu
CREATE TABLE Restaurant.Menu
(
	ItemId INT PRIMARY KEY NOT NULL,
	FoodItemDesc VARCHAR (300) NOT NULL,
	Price VARCHAR (5) NOT NULL
);
GO

--DROP TABLE IF EXISTS Restaurant.OrderDetail
--SELECT*FROM Restaurant.OrderDetail
CREATE TABLE Restaurant.OrderDetail
(
	OrderDetailId INT PRIMARY KEY NOT NULL,
	ItemId INT NOT NULL REFERENCES Restaurant.Menu (ItemId),
	OrderId INT NOT NULL REFERENCES Restaurant.ToOrder(OrderId),
	Quantity INT NOT NULL
);
GO

CREATE INDEX idx_OrderDetailRestaurant
ON Restaurant.OrderDetail(OrderDetailId, ItemId, OrderId, Quantity);

--Checks adding special constraints for CustomerStatus and CostomerDiscount
ALTER TABLE Restaurant.Customer
	ADD CONSTRAINT CHK_CustomerStatus
	CHECK (CustomerStatus = 'Regular' OR CustomerStatus = 'Premium');
GO


ALTER TABLE Restaurant.Customer
	ADD CONSTRAINT CHK_CustomerDiscount
	CHECK (Discount = 0 OR Discount = 10);
GO
--WHEN ELSE statements for discount is 0 or 10
SELECT Discount, CASE
	WHEN Discount = 0 THEN 'Regular'
	WHEN Discount = 10 THEN 'Premium'
	ELSE 'This discount is not available'
	END AS CustomerStatus
FROM Restaurant.Customer
GO


--This procedure was created to join some attributes from the Customer, Payment and ToOrder Tables
--Drop procedure Restaurant.OrderpaymentbycustomerId
CREATE PROCEDURE Restaurant.OrderpaymentbycustomerId
AS
BEGIN
	SELECT c.CustomerId, c.TelephoneNumber, c.FirstName, c.LastName, p.PaymentDate, p.Amount, t.OrderId
	FROM Restaurant.Customer c
	JOIN Restaurant.ToOrder t
		ON c.CustomerId=t.CustomerId
	JOIN Restaurant.Payment p
		ON p.PaymentId = t.PaymentId;
END
GO

--EXEC Restaurant.OrderpaymentbycustomerId
GO

CREATE PROCEDURE Restaurant.CustDeliveryAreaCode
AS
BEGIN
	SELECT c.FirstName, c.LastName, a.Areacode, a.AreaName, d.DeliveryBoyId, d.FirstName, d.LastName
	FROM Restaurant.Customer c
	JOIN Restaurant.AreaCodeField a
		ON c.AreaCode = a.AreaCode
	JOIN Restaurant.DeliveryBoy d
		ON d.DeliveryAreaCode = a.AreaCode;
END
GO

--EXEC Restaurant.CustDeliveryAreaCode

CREATE VIEW Restaurant.CustomerPremium AS 
SELECT CustomerId, FirstName, LastName, CustomerStatus
FROM Restaurant.Customer
WHERE CustomerStatus = 'Premium';
GO

-- SELECT * FROM Restaurant.CustomerPremium

CREATE VIEW Restaurant.CustomerRegular AS 
SELECT CustomerId, FirstName, LastName, CustomerStatus
FROM Restaurant.Customer
WHERE CustomerStatus = 'Regular';
GO

--SELECT * FROM Restaurant.CustomerRegular

CREATE VIEW Restaurant.CustomerCode AS 
SELECT FirstName, LastName, TelephoneNumber, AreaCode
FROM Restaurant.Customer
GO

--SELECT * FROM Restaurant.CustomerCode







