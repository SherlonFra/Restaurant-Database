USE master;
GO

DROP DATABASE IF EXISTS RestaurantManager;
CREATE DATABASE RestaurantManager
GO

USE RestaurantManager;
GO


CREATE SCHEMA Restaurant;
GO


CREATE TABLE Restaurant.AreaCodeField
(
	AreaCode VARCHAR(10) PRIMARY KEY NOT NULL,
	AreaName VARCHAR(200) NOT NULL
);
GO

CREATE TABLE Restaurant.DeliveryBoy
(
	DeliveryBoyId INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	DeliveryAreaCode VARCHAR(10) NOT NULL REFERENCES Restaurant.AreaCodeField(AreaCode)
);
GO


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


CREATE TABLE Restaurant.ToOrder
(
	OrderId INT PRIMARY KEY NOT NULL,
    CustomerId INT NOT NULL REFERENCES Restaurant.Customer (CustomerId),
	PaymentId INT NOT NULL REFERENCES Restaurant.Payment(PaymentId)
);
GO


CREATE TABLE Restaurant.Menu
(
	ItemId INT PRIMARY KEY NOT NULL,
	FoodItemDesc VARCHAR (300) NOT NULL,
	Price VARCHAR (5) NOT NULL
);
GO


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

ALTER TABLE Restaurant.Customer
	ADD CONSTRAINT CHK_CustomerStatus
	CHECK (CustomerStatus = 'Regular' OR CustomerStatus = 'Premium');
GO


ALTER TABLE Restaurant.Customer
	ADD CONSTRAINT CHK_CustomerDiscount
	CHECK (Discount = 0 OR Discount = 10);
GO

SELECT Discount, CASE
	WHEN Discount = 0 THEN 'Regular'
	WHEN Discount = 10 THEN 'Premium'
	ELSE 'This discount is not available'
	END AS CustomerStatus
FROM Restaurant.Customer
GO



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

CREATE VIEW Restaurant.CustomerPremium AS 
SELECT CustomerId, FirstName, LastName, CustomerStatus
FROM Restaurant.Customer
WHERE CustomerStatus = 'Premium';
GO



CREATE VIEW Restaurant.CustomerRegular AS 
SELECT CustomerId, FirstName, LastName, CustomerStatus
FROM Restaurant.Customer
WHERE CustomerStatus = 'Regular';
GO



CREATE VIEW Restaurant.CustomerCode AS 
SELECT FirstName, LastName, TelephoneNumber, AreaCode
FROM Restaurant.Customer
GO








