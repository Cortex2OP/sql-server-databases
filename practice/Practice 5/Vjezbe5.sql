--1. Prikazati količinski najmanju i najveću vrijednost stavke narudžbe. (Northwind)
USE Northwind
SELECT MAX(O.Quantity) AS MAX, MIN(O.Quantity) AS MIN
FROM [Order Details] AS O
--2. Prikazati količinski najmanju i najveću vrijednost stavke narudžbe za svaku od narudžbi pojedinačno. (Northwind)SELECT O.OrderID, MIN(O.Quantity) AS MIN, MAX(O.Quantity) AS MAXFROM [Order Details] AS OGROUP BY O.OrderID--3. Prikazati ukupnu zaradu od svih narudžbi. (Northwind)SELECT SUM(O.Quantity*O.UnitPrice) AS 'Ukupna zarada'FROM [Order Details] AS O--4. Prikazati ukupnu vrijednost za svaku narudžbu pojedinačno uzimajući u obzir i popust.
--Rezultate zaokružiti na dvije decimale i sortirati prema ukupnoj vrijednosti naružbe opadajućem redoslijedu. (Northwind)SELECT O.OrderID, ROUND(SUM((O.Quantity*O.UnitPrice)-(O.Quantity*O.UnitPrice*O.Discount)),2) AS 'Ukupna vrijednost sa popustom'FROM [Order Details] AS OGROUP BY O.OrderIDORDER BY 2 DESC--5. Prebrojati stavke narudžbe gdje su naručene količine veće od 50 (uključujući i graničnu
--vrijednost). Uzeti u obzir samo one stavke narudžbe gdje je odobren popust. (Northwind)SELECT COUNT(O.Quantity)FROM [Order Details] AS OWHERE O.Quantity >= 50 AND O.Discount > 0--6. Prikazati prosječnu cijenu stavki narudžbe za svaku narudžbu pojedinačno. Sortirati po prosječnoj cijeni u opadajućem redoslijedu. (Northwind)SELECT OD.OrderID,AVG(OD.UnitPrice) 'Prosjecna cijena'
FROM [Order Details] AS OD
GROUP BY OD.OrderID
ORDER BY 2 DESC--7. Prikazati broj stavki narudžbi sa odobrenim popustom. (Northwind)SELECT COUNT(O.Discount)FROM [Order Details] AS OWHERE O.Discount > 0--8. Prikazati broj narudžbi u kojima je unesena regija kupovine. (Northwind)SELECT COUNT(O.ShipRegion) 'Unesena regija kupovine'
FROM Orders AS OWHERE O.ShipRegion IS NOT NULL--9. Modificirati prethodni upit tako da se dobije broj narudžbi u kojima nije unesena regija kupovine. (Northwind) SELECT COUNT(*)FROM Orders as OWHERE O.ShipRegion IS NULL--10. Prikazati ukupne troškove prevoza po uposlenicima. Uslov je da ukupni troškovi
--prevoza nisu prešli 7500 pri čemu se rezultat treba sortirati opadajućim redoslijedom
--po visini troškova prevoza. (Northwind)SELECT O.EmployeeID, SUM(O.Freight)FROM Orders as OGROUP BY O.EmployeeIDHAVING SUM(O.Freight) <=7500ORDER BY 2 DESC--11.	Prikazati ukupnu vrijednost troška prevoza po državama ali samo ukoliko je veæa od 4000 za 
--robu koja se kupila u Francuskoj, Njemaèkoj ili Švicarskoj. (Northwind)
SELECT SUM(O.Freight),O.ShipCountry
FROM Orders AS O
WHERE O.ShipCountry IN ('France','Germany','Switzerland')
GROUP BY O.ShipCountry
HAVING SUM(O.Freight)>4000
--12.	Prikazati ukupan broj modela proizvoda. Lista treba da sadrži ID modela proizvoda i njihov ukupan broj. 
--Uslov je da proizvod pripada nekom modelu i da je ukupan broj proizvoda po modelu veæi od 3. 
--U listu ukljuèiti (prebrojati) samo one proizvode èiji naziv poèinje slovom 'S'. (AdventureWorks2017)
USE AdventureWorks2017
SELECT PP.ProductModelID,COUNT(PP.ProductModelID) 'Ukupan broj'
FROM Production.Product AS PP
WHERE PP.ProductModelID IS NOT NULL AND PP.Name LIKE 'S%'
GROUP BY PP.ProductModelID
HAVING COUNT(PP.ProductModelID)>3
