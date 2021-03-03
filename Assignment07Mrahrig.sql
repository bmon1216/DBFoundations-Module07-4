--*************************************************************************--
-- Title: Assignment07
-- Author: Megan Rahrig
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2021-02-24, Megan Rahrig, Created File, answered Qs 1-4
-- 2021-02-25, Megan Rahrig, updated formatting, answered Qs 5 & 6
-- 2021-02-27, Megan Rahrig, finished drafting Qs
-- 2021-02-28, Megan Rahrig, fixed Q8
-- 2021-03-01, Megan Rahrig, tried to fix Q6
-- 2021-03-02, Megan Rahrig, tried to fix Q6
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_MeganRahrig')
	 Begin 
	  Alter Database [Assignment07DB_MeganRahrig] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_MeganRahrig;
	 End
	Create Database Assignment07DB_MeganRahrig;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_MeganRahrig;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!

-- <Put Your Code Here> --

Select ProductName,
Format(UnitPrice, 'C', 'en-US') as UnitpPice
From vProducts 
Order by ProductName
Go

--MR notes: include comma before Format. Place 'C' in single quotes.
--Checked, success

-- Question 2 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Category and Product names, and the price of each product, 
-- with the price formatted as US dollars?
-- Order the result by the Category and Product!

-- <Put Your Code Here> --

Select CategoryName, ProductName,
Format(UnitPrice, 'C', 'en-US') as UnitPrice
From vCategories as c
  Join vProducts as p
   On c.CategoryID = p.CategoryID
Order by CategoryName, ProductName
Go

--Checked, success

-- Question 3 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, each Inventory Date, and the Inventory Count,
-- with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

-- <Put Your Code Here> --

Select ProductName,
Format(InventoryDate, 'MMMM, yyyy', 'en-US') as InventoryDate,
Count as InventoryCount
From vInventories as i
  Join vProducts as p
   On i.ProductID = p.ProductID
Order by ProductName, Month(InventoryDate), InventoryCount
Go

--MR notes: microsoft code for month name is MMMM
--Checked, success


-- Question 4 (10% of pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

-- <Put Your Code Here> --


Go
Create View vProductInventories
As
Select ProductName,
Format(InventoryDate, 'MMMM, yyyy', 'en-US') as InventoryDate,
Count as InventoryCount
From vInventories as i
  Join vProducts as p
   On i.ProductID = p.ProductID
Go

-- Check that it works: Select * From vProductInventories;

Select * from vProductInventories Order by ProductName, Month(InventoryDate), InventoryCount
Go

--Checked, success



-- Question 5 (10% of pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

-- <Put Your Code Here> --

Go
Create view vCategoryInventories
As
Select CategoryName,
Format(InventoryDate, 'MMMM, yyyy', 'en-US') as InventoryDate,
Sum(count) as InventoryCountByCategory
From vInventories as i
  Join vProducts as p
   On i.ProductID = p.ProductID
  Join vCategories as c
   On c.CategoryID = p.CategoryID
Group by CategoryName, InventoryDate
Go

-- Check that it works: Select * From vCategoryInventories;

Select * from vCategoryInventories Order by CategoryName
Go

--Checked, success


-- Question 6 (10% of pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

-- <Put Your Code Here> --

Go
create view vProductInventoriesWithPreviousMonthCounts
As
Select 
  ProductName,
  InventoryDate,
  InventoryCount,
  IsNull(Lag(sum(InventoryCount)) Over (Order By ProductName,Month(InventoryDate)), 0) as PreviousMonthCount
 From vProductInventories
 Group By ProductName, InventoryDate, InventoryCount;
Go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;

Select * from vProductInventoriesWithPreviousMonthCounts Order by ProductName, Month(InventoryDate), InventoryCount
Go

--This is the closest I got. I tried to implement IIF, IsNull, Lag, Lead, etc. from Randal's updated video but with no luck.

--Work shown below:

------------------------------------------------
/*
Go
Create view vProductInventoriesWithPreviouMonthCounts
As
select productname, 
iif(year(inventorydate) = 1996, 0, inventorydate),
inventorycount,
isnull(lead (inventorycount) Over(Order By Month(inventorydate)),0) as previousmonthcount
From vProductInventories
Go
*/
--**********fix 1 item*********-
--he says nothing in the answer "says" 1996
--it should be 2016?? we still need to demonstrate it using if statement
--1996 means that January previous month is zero
/*
Go
create view vProductInventoriesWithPreviousMonthCounts
As
Select ProductName, InventoryDate, InventoryCount,
 iif(year(inventorydate) like '2016', 0, year(inventorydate)),
 --iif(Cast(inventorydate as int) like 2016, 0, inventorydate),
 IsNull(lag (InventoryCount) Over(Order By Month(InventoryDate)),0) as PreviousMonthCount
From vProductInventories
Go
*/
/*
Go
Create view vProductInventoriesWithPreviousMonthCounts
As
Select ProductName, InventoryDate, InventoryCount,
 IsNull(lag (InventoryCount) Over(Order By (productname)),0) as PreviousMonthCount
From vProductInventories
Group By ProductName, InventoryDate, InventoryCount;
Go
*/
/*
Go
Create view vProductInventoriesWithPreviousMonthCounts
As
Select ProductName, InventoryDate, InventoryCount
--IsNull(if(year(inventorydate) = 1996),0) as InventoryDate
--IIF(year(inventorydate) like 1996, 0,)
--IIF(YEAR(inventorydate) Over(Order By year(InventoryDate)),0) as inventorydate
 IIF(Year(InventoryDate) = 1996, 0, Lag(Sum(Quantity)) Over (Order By ProductName,Year(InventoryDate)))
 IsNull(lag (InventoryCount) Over(Order By Month(InventoryDate)),0) as PreviousMonthCount
From vProductInventories
Go
*/
/*
Go
Create view vProductInventoriesWithPreviousMonthCounts
As
Select 
  ProductName,
  InventoryDate,
  InventoryCount,
  IsNull(Lag(Sum(InventoryCount)) Over (Order By ProductName,Year(InventoryDate)), 0) as PreviousMonthCount
 From vProductInventories
 Group By ProductName, InventoryDate, InventoryCount;
Go
Select * from vProductInventoriesWithPreviousMonthCounts Order by productname, month(InventoryDate), InventoryCount
Go
*/
/*
Select 
  ProductName,
  IIF(Year(InventoryDate) = 2016, 0, Lag(month(InventoryDate)) Over (Order By ProductName,Year(InventoryDate))) as InventoryDate,
  InventoryCount,
  IsNull(Lag(Sum(InventoryCount)) Over (Order By ProductName,Year(InventoryDate)), 0) as PreviousMonthCount
 From vProductInventories
 Group By ProductName, InventoryDate, InventoryCount;
Go
*/
/*
Go
Create view vProductInventoriesWithPreviousMonthCounts
As
Select 
  ProductName,
  InventoryDate,
  IIF(month(inventorycount) = 1, Lag(sum(PreviousMonthCount)) Over (Order By ProductName,sum(PreviousMonthCount)), 0),
  IsNull(Lag(Sum(InventoryCount)) Over (Order By ProductName,month(InventoryDate)), 0) as PreviousMonthCount,
  InventoryCount
 From vProductInventories
 Group By ProductName, InventoryDate, InventoryCount;
Go
*/
/*
Select 
  ProductName,
  InventoryDate,
  Inventorycount,
  IIF(month(inventorycount) = 1, Lag(sum(inventorycount)) Over (Order By sum(inventorycount)) as InventoryCount,
  IsNull(Lag(Sum(InventoryCount)) Over (Order By ProductName,month(InventoryDate)), 0) as PreviousMonthCount
 From vProductInventories
 Group By ProductName, InventoryDate, InventoryCount;
Go
*/




-- Question 7 (20% of pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the 
-- Product, Date, and Count!

-- <Put Your Code Here> --

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!

Go
Create view vProductInventoriesWithPreviousMonthCountsWithKPIs
As
Select ProductName, InventoryDate, InventoryCount, PreviousMonthCount, CountVsPreviousCountKPI = case 
   When InventoryCount > PreviousMonthCount Then 1
   When InventoryCount = PreviousMonthCount Then 0
   When InventoryCount < PreviousMonthCount Then -1
   End
From vProductInventoriesWithPreviousMonthCounts
Go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;

Select * from vProductInventoriesWithPreviousMonthCountsWithKPIs Order by ProductName, Month(InventoryDate), InventoryCount
Go

--Checked, success

-- Question 8 (25% of pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

-- <Put Your Code Here> --

Create function dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs (@countvspreviouscountkpi int)
Returns table
As
Return(Select TOP 1000000000
ProductName, InventoryDate, InventoryCount, PreviousMonthCount, CountVsPreviousCountKPI
From dbo.vProductInventoriesWithPreviousMonthCountsWithKPIs
Where CountVsPreviousCountKPI = @CountVsPreviouscountKPI
Order by Year(Cast(InventoryDate as Date)))
Go
--Note what effect it has on the results: it appears to order results by product name 
--even though the order by statement is related to the year. I guess since all of the years
--are 2017, it reverts to ordering by the first column. 


/* Check that it works:*/
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);

go

/***************************************************************************************/