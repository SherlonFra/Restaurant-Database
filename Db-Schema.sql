--Name of Restaurant DataBase
CREATE DATABASE RestaurantManager

USE Sherlon;

--Schema Name for Restaurant System
CREATE SCHEMA Restaurant;
GO

CREATE TABLE DeliveryBoy
(
	DeliveryBoyId INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	DeliveryAreaCode INT NOT NULL
);
GO

CREATE TABLE AreaCodeField
(
	AreaCode INT PRIMARY KEY NOT NULL REFERENCES DeliveryBoy(DeliveryBoyId),
	AreaName VARCHAR(200) NOT NULL
);
GO


CREATE TABLE OrderDetail
(
	OrderDetailId INT PRIMARY KEY NOT NULL,
	ItemId INT NOT NULL,
	OrderId INT NOT NULL UNIQUE,
	Quantity INT NOT NULL
);
GO
--Index for OrderDetail Table
CREATE INDEX idx_OrderDetail
ON OrderDetail(OrderDetailId, ItemId, OrderId, Quantity);

CREATE TABLE ToOrder
(
	OrderId INT PRIMARY KEY NOT NULL REFERENCES OrderDetail(OrderDetailId),
    TelephoneNumber INT NOT NULL,
	PaymentId INT NOT NULL
);
GO

CREATE TABLE Customer
(
	TelephoneNumber INT PRIMARY KEY NOT NULL REFERENCES ToOrder(OrderId),
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	AreaCode INT NOT NULL REFERENCES AreaCodeField(AreaCode),
	OrderLocation VARCHAR(10) NOT NULL,
	CustomerStatus VARCHAR(10) NOT NULL,
	Discount INT NOT NULL
);
GO
--Checks adding special constraints for CustomerStatus and CostomerDiscount
ALTER TABLE Customer
	ADD CONSTRAINT CHK_CustomerStatus
	CHECK (CustomerStatus = 'Regular' OR CustomerStatus = 'Premium');
GO

ALTER TABLE Customer
	ADD CONSTRAINT CHK_CustomerDiscount
	CHECK (Discount = 0 OR Discount = 10);
GO
--WHEN ELSE statements for discount is 0 or 10
SELECT Discount, CASE
	WHEN Discount = 0 THEN 'Regular'
	WHEN Discount = 10 THEN 'Premium'
	ELSE 'This discount is not available'
	END AS CustomerStatus
FROM Customer
GO

CREATE TABLE Menu
(
	ItemId INT PRIMARY KEY NOT NULL REFERENCES OrderDetail(OrderdetailId),
	FoodItemDesc VARCHAR (300) NOT NULL,
	Price DECIMAL (3,2) NOT NULL
);
GO


CREATE TABLE Payment
(
	PaymentId INT PRIMARY KEY NOT NULL REFERENCES ToOrder(OrderId),
	PaymentDate DATE NOT NULL,
	Amount DECIMAL (5,2) NOT NULL,
	PaymentType VARCHAR(20) NOT NULL
);
GO


CREATE INDEX idx_Payment
ON Payment(PaymentId, PaymentDate, Amount, PaymentType);
GO

--This procedure was created to join some attributes from the Customer, Payment and ToOrder Tables
--Drop procedure OrderpaymentbycustomerId
CREATE PROCEDURE OrderpaymentbycustomerId
AS
BEGIN
	SELECT c.TelephoneNumber, c.FirstName, c.LastName, p.PaymentDate, p.Amount, t.OrderId
	FROM Customer c
	JOIN ToOrder t
		ON c.TelephoneNumber=t.TelephoneNumber
	JOIN Payment p
		ON p.PaymentId = t.PaymentId;
END
GO

--EXEC OrderpaymentbycustomerId

CREATE PROCEDURE CustDeliveryAreaCode
AS
BEGIN
	SELECT c.FirstName, c.LastName, a.Areacode, a.AreaName, d.DeliveryBoyId, d.FirstName, d.LastName
	FROM Customer c
	JOIN AreaCodeField a
		ON c.AreaCode = a.AreaCode
	JOIN DeliveryBoy d
		ON d.DeliveryAreaCode = a.AreaCode;
END
GO

--EXEC CustDeliveryAreaCode
