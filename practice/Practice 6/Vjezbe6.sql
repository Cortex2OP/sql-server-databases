--1. Prikazati tip popusta, naziv prodavnice i njen id. (Pubs)
SELECT D.discounttype, S.stor_name, S.stor_id
FROM dbo.stores AS S
INNER JOIN dbo.discounts AS D
ON D.stor_id = S.stor_id
--2. Prikazati ime uposlenika, njegov id, te naziv posla koji obavlja. (Pubs)SELECT E.fname + ' ' + E.lname AS 'Ime i prezime', E.emp_idFROM dbo.employee AS EINNER JOIN jobs AS JON J.job_id = E.job_id--3. Prikazati spojeno ime i prezime uposlenika, teritoriju i regiju koju pokriva. Uslov je da
--su zaposlenici mlađi od 60 godina. (Northwind)SELECT E.FirstName + ' ' + E.LastName AS 'Ime i prezime' , T.TerritoryDescription, R.RegionDescription, e.BirthDateFROM Employees AS E INNER JOIN EmployeeTerritories AS ETON ET.EmployeeID=E.EmployeeIDINNER JOIN Territories AS TON T.TerritoryID = ET.TerritoryIDINNER JOIN Region AS RON R.RegionID = T.RegionIDWHERE (YEAR(GETDATE()) - YEAR(E.BirthDate)) < 60--4. Prikazati ime uposlenika i ukupnu vrijednost svih narudžbi koju je taj uposlenik
--napravio u 1996. godini. U obzir uzeti samo one uposlenike čija je ukupna napravljena 
--vrijednost veća od 20000. Podatke sortirati prema ukupnoj vrijednosti (zaokruženoj na
--dvije decimale) u rastućem redoslijedu. (Northwind)
SELECT E.EmployeeID,SUM(OD.UnitPrice*OD.Quantity)'Ukupna vrijednost'
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1996
GROUP BY E.EmployeeID
HAVING SUM(OD.UnitPrice*OD.Quantity)>20000
ORDER BY 2 
--5. Prikazati naziv dobavljača, adresu i državu dobavljača i nazive proizvoda koji pripadaju
--kategoriji pića i ima ih na stanju više od 30 komada. Rezultate upita sortirati po
--državama. (Northwind)
SELECT S.ContactName, S.[Address], S.Country, P.ProductName
FROM Suppliers AS S
INNER JOIN Products AS P
ON P.SupplierID = S.SupplierID
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID
WHERE C.Description LIKE '%drinks%' AND P.UnitsInStock > 30
ORDER BY 3
--6. Prikazati kontakt ime kupca, njegov id, broj narudžbe, datum kreiranja narudžbe
--(prikazan na način npr 24.07.2021) te ukupnu vrijednost narudžbe sa i bez popusta.
--Prikazati samo one narudžbe koje su kreirane u 1997. godini. Izračunate vrijednosti
--zaokružiti na dvije decimale, te podatke sortirati prema ukupnoj vrijednosti narudžbe
--sa popustom. (Northwind)USE Northwind
SELECT C.ContactName,C.CustomerID,O.OrderID,FORMAT(O.OrderDate,'dd.MM.yyyy') AS 'Datum kreiranja narudžbe', SUM(OD.UnitPrice*OD.Quantity) 'Ukupno bez popusta',ROUND(SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)),2) 'Ukupno sa popustom'
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD
ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY C.ContactName,C.CustomerID,O.OrderID,FORMAT(O.OrderDate,'dd.MM.yyyy')
ORDER BY 6 DESC
--7. U tabeli Customers baze Northwind ID kupca je primarni ključ.
--U tabeli Orders baze Northwind ID kupca je vanjski ključ.
--Prikazati:
--a) Koliko je kupaca evidentirano u obje tabele
--b) Da li su svi kupci obavili narudžbu
--c) Ukoliko postoje neki da nisu prikazati koji su to