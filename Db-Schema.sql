
CREATE DATABASE RestaurantManager

USE Sherlon;

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

SELECT*FROM Payment

