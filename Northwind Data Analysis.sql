select orderid, ProductName	
from [Order Details] OD
join Products P
on od.ProductID = P.ProductID
where ProductName= 'chai' or ProductName= 'Tofu'


--5. Find the name of the company that placed order 10290.
Select Orderid, companyName
From orders O
join customers C
on o.customerID = C.customerID
where Orderid = 10290


--6. Find the name of the company that placed order between 10250 and 10260
Select Orderid, companyname
from orders O
join customers C
on o.customerID= C.customerID
--where Orderid >= 10250 and orderid <= 10260
where orderid between 10250 and 10260

--6. Find the Companies that placed orders in 1997.
Select orderid,YEAR (orderdate) ,companyname customername
from orders O 
join customers C 
on O.customerid= C.customerid
where YEAR (Orderdate) = 1997

--6.1 Find the Companies that placed orders in 1997 and in the month of August
Select orderid, companyname, YEAR(orderdate) orderyear, MONTH(orderdate), orderdate
from orders O
join customers C
on o.customerid = c.customerid
where YEAR(orderdate) = 1997 and Month(orderdate) = 8

--6.2 Find the Companies that placed orders on 1st August 1997
select orderid,companyname,orderdate
from orders o
join customers c
on o.customerid = c.customerid
where orderdate = '08/01/1997'

--7. Get the list of employees who processed the order for “chai”.
--Employee, orders, product, orderdetail
select Emp.LastName,Emp.FirstName,Prod.ProductName
From [Order Details] OrdDet
join Orders ord
on ordDet.orderid = ord.orderid
join Employees Emp
on Ord.EmployeeID = Emp.EmployeeID
join products prod
on orddet.productid = prod.productid
where prod.productname = 'chai'


--8. Get the shipper company who processed the order for categories “Seafood” and "Dairy Products"
--Shippers, Orders,Categories,Order DEtails,Product
Select ship.CompanyName, Cat.CategoryName
From [Order Details] OrdDet
join products prod
on OrdDet.ProductID = Prod.ProductID
join Categories Cat
ON Prod.CategoryID = Cat.CategoryID
join Orders ord
on OrdDet.OrderID = Ord.OrderID
join Shippers Ship
on Ord.ShipVia = Ship.ShipperID
where Cat.CategoryName = 'Seafood' or Cat.CategoryName = 'Dairyproducts'

--9. Create a report showing the product name, unit price and quantity per unit of all products that are out of stock
select* from products

select productname, unitprice,quantityperunit,UnitsInStock
from products
where UnitsInStock= 0


--10. Create a report that shows the company name, contact name and fax number of all customers that have a fax number.
Select CompanyName, Contactname, Fax
From Customers

-- Give list of order details for the orders 10248,10249,10250,10251,10252,10253,10254,10255,10256,10257
SELECT * from
orders
where OrderID IN (10248,10249,10250,10251,10252,10253,10254,10255,10256,10257)

--11. Create a report that shows the shipping postal code, order id, and order date for all orders with a ship postal code beginning with "02389".
select * from Orders
Orderid,ShipPostalCode,orderdate
From Orders
where shipPostalcode Like '02389%'
select * from Orders
Orderid,ShipPostalCode,orderdate
From Orders
where shippostalcode Like '%876'

--12. Create a report that shows the contact name and title and the company name for all customers whose contact title contain the word "Sales".
select ContactName,ContactTitle,CompanyName
from Customers
where ContactTitle like '%sales%'

-- Display Order details along with Sale Amount
select *, (unitprice* quantity) SalesAmount
from [Order Details]

select *, (unitprice* quantity)* (1-Discount) SalesDicsAmountBrack
from [Order Details]

--AGGREGATE FUNCTIONS

--1.  Orderwise Sales from Orderdetails
select orderid, sum((unitprice* quantity)* (1-Discount)) SalesAmount
from [Order Details]
group by OrderID

--1.  Orderwise Quantity from Orderdetails
select orderid,sum(quantity) OrderWiseQuantity
from [Order Details]
group by OrderID

-- ProductId wise Sales from Order Details
select productid,sum((unitprice*quantity)*(1-Discount)) ProductWiseSale
from [Order Details]
group by ProductID

--2. ProductId and Productname wise Quantity from OrderDetails
select OD.ProductID,ProductName,sum(quantity) ProductWiseQuantity
from [Order Details] OD
JOin products P
on OD.ProductID = P.ProductID
Group by OD.ProductID, productNAme
order by ProductID

--2. ProductId and Productname wise Sales from OrderDetails
select OD.Productid,productname,SUM((UnitPrice*quantity)*(1-discount)) productWiseSales
from [Order Details] OD
join products Prd
on od.ProductId = Prd.ProductID
group by OD.ProductId,prd.productname

--3. Find the number of orders sent by each shipper, sent by each employee
select S.Companyname,e.firstname, e.lastname, count(o.orderid) NoOfOrders
from orders o
join shippers s on o.shipvia = s.shipperid
join employees e on o.employeeid = e.employeeid
group by S.companyname, e.firstname, e.lastname

--4. Find Category wise, product wise total sale 
select c.categoryid,p.productname,sum((OD.Quantity * OD.UnitPrice)*(1-discount)) totalsales
from [Order Details].OD
On OD.ProductID = P.ProductID
JOIN Categories C
    ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName, P.ProductName
having sum((OD.Quantity * OD.UnitPrice)*(1-discount))


--8. Give a list of all customers along with the total number of orders they placed.
select c.companyname,count(o.OrderID) as NoOfOrders
from order O
join customer C on O.CustomerID O.CustomerID
group by C.CompanyName

--9. Month wise Orders raised by each employee for Year 1998
select e.EmployeeID,e.firstname +''+ e.lastname as employeename, month(o.OrderDate) as 

-- Country wise Customer wise no. of products ordered for year 1997
select c.country, c.customerId, C.CompanyName as CustomerName,Count(od.ProductID) aS ProductCount
from customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.orderID = od.OrderID
where year(o.OrderDate) = 1997
group by c.country, c.CustomerID, c.CompanyName

-- Display Average totalsale per Order
select sum((O.UnitPrice*o.Quantity)*(1-O.Discount))/count(distinct O.OrderID) As AverageSale
from [Order Details] O

go
--04)    Query That Gives Category Id and Category Name Wise Total Sales
with CategoryWiseTotal as
(
select P.CategoryID, round(sum((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)),2) as TotsalSalesAmount
from [Order Details] OD
join Products P on OD.ProductID=P.ProductID
group by P.CategoryID
)
select CatTot.CategoryID, C.CategoryName, CatTot.TotsalSalesAmount as CategoryWisesales
from CategoryWiseTotal CatTot
join Categories C on Cattot.CategoryID = C.CategoryID
order by CategoryWisesales desc


--05)    Query That Gives Customers Company Name Wise Total Sales for the Year 1997 Of Order Date
(
select o.customerID, sum((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) as SalesAmount
from [Order Details] OD
join Orders O on OD.orderID = O.OrderID
where Year(o.OrderDate)=1997
group by O.CustomerID
)
Select C.CompanyName, T.SalesAmount
from TotSalesAmount T
join Customers C ON T.CustomerID=c.CustomerID
Order by C.CompanyName desc
go

--06)    Query to Give Customer Id and Cust Company Name Who Did Not Place Any Order in Year 1997 Of Order Date
Select CustomerID,CompanyName from dbo.Customers;
with Cust as
(
select O.CustomerID OCid, year(O.OrderDate) OrderYear
from Orders O
where year(O.OrderDate)=1997
)
Select CST.OCid,C.CustomerID,C.CompanyName, CST.OrderYear
From Cust CST
Right join Customers C on CST.OCid=C.CustomerID
where CST.OCid is null


--13) Names of customers to whom we are sellinng less than average sales per cusotmer
WITH CustwiseTotSales AS
(
SELECT C.CustomerID, C.CompanyName, SUM((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) AS SalesAmount
FROM [Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CompanyName
),
AvgSale AS
(
SELECT AVG(SalesAmount) AS AvgSalesAmt
FROM CustwiseTotSales CustTot
)
SELECT CTS.CompanyName,CTS.SalesAmount, AvgSalesAmt
FROM CustwiseTotSales CTS 
CROSS JOIN AvgSale 
WHERE CTS.SalesAmount < AvgSalesAmt

       
--14)    Query That Gives Average Freight Per Employee and Average Freight Per Customer
with AvgEmpWiseFreight as
(
select sum(O.freight)/count (distinct O.EmployeeID) AvgEmpWiseFreight
from orders O
),
AvgCutwiseFreight as
(
select sum(O.freight)/ count(distinct o.CustomerId) AvgCutWiseFreight
from orders o
)
select AEF.AvgEmpWiseFreight, ACF.AvgCutWiseFreight
from AvgEmpWiseFreight AEF
CROSS JOIN AvgCutwiseFreight ACF
go

--15) Find out the contribution of each employee towards the total sales done by Northwind
with EmpWiseSalesTot as
(
select concat(E.FirstName,'',E.LastNAme) EmpName,sum((OD.Unitprice*OD.Quantity)*(1-OD.Discount)) as SalesAmount
from [Order Details] OD
join Orders O on OD.OrderID= O.OrderID
join Employees E on O.EmployeeID = E.EmployeeID
group by concat(E.FirstName,'',E.LastName)
),
TotSales as
(
select round(sum((OD.Unitprice * OD.Quantity)*(1-OD.Discount)),2) as TotSalesAmount
from [Order Details] OD
)
select EST.EmpName,round(EST.SalesAmount,2) Saleamt,round (TS.TotSalesAmount,2) totSalesAmt,
round((EST.SalesAmount/TS.TotSalesAmount)*100,2) as PercContribution
from EmpWiseSalesTot EST
cross join TotSales TS 
order by PercContribution desc

--16)   Query That Gives Category Id, Category Name, Category Wise Total Sale  Where Category Total Sale Is Less Than the Average Sale Per Category
WITH CategorySales AS 
(
SELECT c.CategoryID c.CategoryName,
SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS CategoryTotalSale
FROM Categories c
JOIN Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID
JOIN Orders o
ON od.OrderID = o.OrderID
GROUP BY c.CategoryID, c.CategoryName
),
AverageSale AS (
SELECT AVG(CategoryTotalSale) AS AvgCategorySale
FROM CategorySales
)
SELECT cs.CategoryID, cs.CategoryName,cs.CategoryTotalSale
FROM CategorySales cs
CROSS JOIN AverageSale a
WHERE cs.CategoryTotalSale < a.AvgCategorySale;

--15)    Query That Provides Month No and Month Total Sales Is Less Than Average Sale for Month for Year of Order Date 1997

-- Top 3 performing Customers by Sales
with CustWiseSales as
(
select c.companyname, sum((OD.unitprice*OD.Quantity)*(1-OD.DIscount)) as salesAmount,
RANK () over (order by sum((OD.unitprice*OD.Quantity)*(1-OD.DIscount)) desc) as CustomerRank
from [order details] OD
join orders O on OD.OrderID = O.OrderID
join customers c on O.CustomerID = C.CustomerID
group by C.CompanyName
)
select CS.CompanyName, CS.SalesAmount,CS.CustomerRank
from CustWiseSales CS
where cs.CustomerRank <=3
go

-- Top 5 performing employees by freight cost
with EMPWiseTotFreight as
(
select concat(E.firstname,'',E.LastName) EmployeeName, sum(O.Freight) as Totfr,
RANK() over
( order by sum(0.freight)
)EmpFrRank
from Orders O
join Employees E on O.EmployeeID=E.EmployeeID
group by CONCAT (E.FirstName,'',E.LastName)
)
select EMPtot.EmployeeName, EMPTot.TotFr, EmpFrRank
from EMPWiseTotFreight EMPTot
where EMPTot.EmpFrRank <=5
go

-- Find the bottom 5 customers per product based on Sales Amount
with ProductWiseCutWiseTotSales as
(
select P.ProductName, C.CompanyNAme, round(sum((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) ,2
RANK() over
(
order by sum((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) 
)ProductWiseTotRank
from [Oder Details] OD
join products P on OD.ProductId = P.ProductID
join orders O on OD.OrderID = O.OrderID
join Customers C on O.CustomerID = C.CustomerID
group by P.ProductName, C.CompanyName
)
select PCT.ProductName, PCT.ComapanyName, PCT.SalesAmount, PCT.ProductWiseTotRank
from ProductWiseCustWiseTotSales PCT
where PCT.ProductWiseTotRank<=5
go

--Give Top Manager for every product by Sales Amount
with ProductMrgWiseTotSales as
(
select PR.ProductName, m.FirstName, m.LastName, sum((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) as SalesAmount,
RANK() OVER
(
PARTITION BY PR.ProductName
ORDER BY SUM((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) desc
) ProductWiseTotRank
FRom [Order Details] OD
join Products PR on OD.ProductID=PR.ProductID
join Orders O ON OD.OrderID = O.OrderID
join Employees E on O.EmployeeID=E.EmployeeID
join Employees m
on e.ReportsTo=m.EmployeeID
group by PR.ProductName,m.FirstName,m.LastName
)
select PrgMrgSale.ProductName,PrgMrgSale.FirstName,PrgMrgSale.LastName,PrgMrgSale.SalesAmount,PrgMrgSale.ProductWiseTotRank
from ProductMrgWiseTotSales PrgMrgSale
where PrgMrgSale.ProductWiseTotRank=1
go

-- Display first and the last Employee based on employeeid
with Employee as
(
select EmployeeID , LastName, FirstName,
RANK() over(Order by EmpolyeeID Desc) as LastRow,
RANK() over(Order by EmpolyeeID asc) as firstRow,
from Employees
)
select EmployeeID,LastName,FirstName, LastRow, FirstRow
from Employee
where FirstRow= 1 or lastrow=1

--Rank, Dense_Rank
select ProductId, ProductName,UnitsInStock,
RANK() OVER (
Order by UnitsInStock Desc
)StockRank
from Products

select ProductId, ProductName,UnitsInStock,
Dense_RANK() OVER (
Order by UnitsInStock Desc
)StockRank
from Products

select ProductId, ProductName,UnitsInStock,
row_number() OVER (
Order by UnitsInStock Desc
)StockRank
from Products

--Lead- Display Next Record Value with Previous Record value
select  PRODUCTID, sum(quantity*unitprice),1) over
(

--Top 30% products in each category by their sale in 1997
with ProductSales as(
select p.ProductID, p.ProductNAme, c.CategoryNAme, sum((od.UnitPrice* od.Quantity)*(1-Discount)) as TotalSales,
rank() over (Partition by c.CategoryID order by sum((od.UnitPrice* od.Quantity)*(1-Discount)) desc) as SalesRank,
count(*) over (partition by c.CategoryID) as CategoryCount
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join orders o on od.orderID = o.OrderID
join Categories c on p.CategoryID= c.CategoryID
where year(o.OrderDate) =1997
group by p.ProductID, p.ProductNAme, c.CategoryName, c.CategoryID
)
select ProductID,ProductName,CategoryName,Totalsales, SalesRank,CategoryCount, (0.3*CategoryCount) ThirtyPerc
from ProductSales
where SalesRank<= 0.3*CategoryCount
order by CategoryName, TotalSales desc;
;
--Bottom 40% countries by freight for 1997 with freight sale ratio
with ShipCountrySale as(
select Country, sum(o.freight) CountryFreight,
Rank() OVER (Order BY sum(freight) asc) as freightRank
from orders o
join Customers c On o.CustomerID= c.CustomerID
where year(o.OrderDate)=1997
group by country
),
MaxFreightRnk as
(
select Max(FreightRank) MAxFrRnk from ShipCountrySale
)
select Country, CountryFreight, freightRank
From shipCountrySale
cross join MaxFreightRnk
where FreightRank<=0.4*MaxFrRnk
order by CountryFreight asc;



