--1. Prikazati količinski najmanju i najveću vrijednost stavke narudžbe. (Northwind)
USE Northwind
SELECT MAX(O.Quantity) AS MAX, MIN(O.Quantity) AS MIN
FROM [Order Details] AS O
--2. Prikazati količinski najmanju i najveću vrijednost stavke narudžbe za svaku od narudžbi pojedinačno. (Northwind)SELECT O.OrderID, MIN(O.Quantity) AS MIN, MAX(O.Quantity) AS MAXFROM [Order Details] AS OGROUP BY O.OrderID--3. Prikazati ukupnu zaradu od svih narudžbi. (Northwind)SELECT SUM(O.Quantity*O.UnitPrice) AS 'Ukupna zarada'FROM [Order Details] AS O--4. Prikazati ukupnu vrijednost za svaku narudžbu pojedinačno uzimajući u obzir i popust.
--Rezultate zaokružiti na dvije decimale i sortirati prema ukupnoj vrijednosti naružbe opadajućem redoslijedu. (Northwind)SELECT O.OrderID, ROUND(SUM((O.Quantity*O.UnitPrice)-(O.Quantity*O.UnitPrice*O.Discount)),2) AS 'Ukupna vrijednost sa popustom'FROM [Order Details] AS OGROUP BY O.OrderIDORDER BY 2 DESC--5. Prebrojati stavke narudžbe gdje su naručene količine veće od 50 (uključujući i graničnu
--vrijednost). Uzeti u obzir samo one stavke narudžbe gdje je odobren popust. (Northwind)
