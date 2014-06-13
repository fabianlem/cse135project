DROP TABLE IF EXISTS CustomerSales, StateSales, ProductSales, StateFilterSales, RightColumnCust1, RightColumnCust2;

CREATE TABLE CustomerSales (
	uName	TEXT REFERENCES Users(name),
	pId 	INTEGER REFERENCES Products(id),
	cName	TEXT REFERENCES Categories(name),
	total	INTEGER);

CREATE TABLE StateSales (
	state 	TEXT,
	pId 	INTEGER REFERENCES Products(id),
	cName	TEXT REFERENCES Categories(name),
	total	INTEGER);

CREATE TABLE ProductSales (
	pName	TEXT,
	pId 	INTEGER REFERENCES Products(id),
	cName	TEXT REFERENCES Categories(name),
	total	INTEGER);

CREATE TABLE StateFilterSales (
	uName	TEXT REFERENCES Users(name),
	state 	TEXT,
	pId 	INTEGER REFERENCES Products(id),
	cName	TEXT REFERENCES Categories(name),
	total	INTEGER);

CREATE TABLE RightColumnCust1 (
	uName	TEXT REFERENCES Users(name),
	total	INTEGER);

CREATE TABLE RightColumnCust2 (
	uName	TEXT REFERENCES Users(name),
	state 	TEXT,
	total	INTEGER);

INSERT INTO CustomerSales (
	(SELECT Users.name AS uName, Products.id AS pId, Categories.name AS cName, SUM(Sales.price*Sales.quantity) AS total
	FROM Sales LEFT OUTER JOIN Users ON (Sales.uid = Users.id) LEFT OUTER JOIN Products ON (Sales.pid = Products.id) LEFT OUTER JOIN Categories ON (Products.cid = Categories.id)
	GROUP BY Users.name, Products.id, categories.name)
);

INSERT INTO StateSales (
	(SELECT Users.state AS state, Products.id AS pID, Categories.name AS cName, SUM(Sales.price*Sales.quantity) AS total
	FROM Sales LEFT OUTER JOIN Users ON (Sales.uid = Users.id) LEFT OUTER JOIN Products ON (Sales.pid = Products.id) LEFT OUTER JOIN Categories ON (Products.cid = Categories.id)
	GROUP BY Users.state, products.id, categories.name)
);

INSERT INTO ProductSales (
	(SELECT Products.name AS pName, Products.id AS pId, Categories.name AS cName, SUM(Sales.price*Sales.quantity) AS total
	FROM Sales LEFT OUTER JOIN Products ON (Sales.pid = Products.id) LEFT OUTER JOIN Categories ON (Products.cid = Categories.id)
	GROUP BY products.name, products.id, categories.name)
);

INSERT INTO StateFilterSales(
	(SELECT Users.name AS uName, Users.state AS state, Products.id AS pId, Categories.name AS cName, SUM(Sales.price*Sales.quantity) AS total
	FROM Sales LEFT OUTER JOIN Users ON (Sales.uid = Users.id) LEFT OUTER JOIN Products ON (Sales.pid = Products.id) LEFT OUTER JOIN Categories ON (Products.cid = Categories.id)
	GROUP BY Users.name, Users.state, Products.id, categories.name)
);

INSERT INTO RightColumnCust1(
	(SELECT uname AS uName, SUM(total) AS total
	FROM CustomerSales
	GROUP BY CustomerSales.uName order by total desc)
);

INSERT INTO RightColumnCust2(
	(select uname as uName, state as state, sum(total) as total 
	from statefiltersales 
	group by statefiltersales.uname, statefiltersales.state order by state)
);

/* 
	SELECT COALESCE(SUM(c.total),0) AS total, p.total AS ptot
	FROM (SELECT pId, total FROM ProductSales ORDER BY total DESC LIMIT 10) AS p
		LEFT OUTER JOIN (SELECT pId, total FROM CustomerSales WHERE uName = \'########\') AS c ON (p.pId = c.pId)
	GROUP BY p.pId, p.total
	ORDER BY p.total DESC
 */
