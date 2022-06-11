--Kroz SQL kod kreirati bazu podataka sa imenom vašeg broja indeksa. 

CREATE DATABASE IB200262
GO
USE IB200262

/*
U kreiranoj bazi podataka kreirati tabele sa sljedećom strukturom: 
PROIZVODI

ProizvodID, cjelobrojna vrijednost i primarni ključ 
Naziv, 40 UNICODE karaktera (obavezan unos) 
Cijena, novčani tip (obavezan unos) 
KoličinaNaSkladistu, smallint  
NazivKompanijeDobavljaca, 40 UNICODE (obavezan unos) 
Raspolozivost, bit (obavezan unos) 

NARUDZBE

NarudzbaID, cjelobrojna vrijednost i primarni ključ, 
DatumNarudzbe, polje za unos datuma 
DatumPrijema, polje za unos datuma 
DatumIsporuke, polje za unos datuma 
Drzava, 15 UNICODE znakova 
Regija, 15 UNICODE znakova 
Grad, 15 UNICODE znakova 
Adresa, 60 UNICODE znakova 

STAVKENARUDZBE

NarudzbaID, cjelobrojna vrijednost, strani ključ 
ProizvodID, cjelobrojna vrijednost, strani ključ 
Cijena, novčani tip (obavezan unos), 
Količina, smallint (obavezan unos), 
Popust, real vrijednost (obavezan unos) 

**Jedan proizvod se može naći na više narudžbi, dok jedna narudžba može imati više proizvoda. U okviru jedne narudžbe jedan proizvod se ne može pojaviti više od jedanput. 
*/
GO
CREATE TABLE Proizvodi 
(
ProizvodID INT PRIMARY KEY,
Naziv NVARCHAR(40) NOT NULL,
Cijena MONEY NOT NULL,
KolicinaNaSkladistu SMALLINT,
NazivKompanijeDobavljaca NVARCHAR(40) NOT NULL,
Raspolozivost BIT NOT NULL,
)
GO

GO
CREATE TABLE Narudzbe 
(
NarudzbaID INT PRIMARY KEY,
DatumNarudzbe DATE,
DatumPrijema DATE,
DatumIsporuke DATE,
Drzava NVARCHAR(15),
Regija NVARCHAR(15),
Grad NVARCHAR(15),
Adresa NVARCHAR(50)
)
GO

GO
CREATE TABLE StavkeNarudzbe 
(
NarudzbaID INT CONSTRAINT FK_StavkeNarudzbe_Narudzba FOREIGN KEY REFERENCES Narudzbe(NarudzbaID),
ProizvodID INT CONSTRAINT FK_StavkeNarduzbe_Proizvodi FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
Cijena MONEY NOT NULL,
Kolicina SMALLINT NOT NULL,
Popust REAL NOT NULL
)
GO

/*
Iz baze podataka Northwind u svoju bazu podataka prebaciti sljedeće podatke: 
U tabelu Proizvodi dodati sve proizvode  
ProductID -> ProizvodID 
ProductName -> Naziv 	 
UnitPrice -> Cijena 	 
UnitsInStock -> KolicinaNaSkladistu 
CompanyName -> NazivKompanijeDobavljaca	 
Discontinued -> Raspolozivost 	 
*/

INSERT INTO Proizvodi(ProizvodID,Naziv,Cijena,KolicinaNaSkladistu,NazivKompanijeDobavljaca,Raspolozivost)
SELECT N.ProductID, N.ProductName, N.UnitPrice, N.UnitsInStock, S.CompanyName, N.Discontinued
FROM Northwind.dbo.Products AS N
JOIN Northwind.dbo.Suppliers AS S ON S.SupplierID = N.SupplierID

/*
U tabelu Narudzbe dodati sve narudžbe, na mjestima gdje nema pohranjenih podataka o regiji zamijeniti vrijednost sa nije naznaceno 

OrderID -> NarudzbaID 
OrderDate -> DatumNarudzbe 
RequiredDate -> DatumPrijema 
ShippedDate -> DatumIsporuke 
ShipCountry -> Drzava 
ShipRegion -> Regija 
ShipCity -> Grad 
ShipAddress -> Adresa 
*/

INSERT INTO Narudzbe(NarudzbaID,DatumNarudzbe, DatumPrijema, DatumIsporuke, Drzava, Regija, Grad, Adresa) 
SELECT O.OrderID, O.OrderDate, O.RequiredDate, O.ShippedDate, O.ShipCountry, O.ShipRegion, O.ShipCity, O.ShipAddress
FROM Northwind.dbo.Orders AS O

UPDATE Narudzbe
SET Regija = 'nije naznaceno'
WHERE Regija IS NULL

/*
U tabelu StavkeNarudzbe dodati sve stavke narudžbe gdje je količina veća od 4 

OrderID -> NarudzbaID 
ProductID -> ProizvodID 
UnitPrice -> Cijena 
Quantity -> Količina 
Discount -> Popust 
*/
INSERT INTO StavkeNarudzbe(NarudzbaID, ProizvodID, Cijena, Kolicina, Popust)
SELECT OD.OrderID, OD.ProductID, OD.UnitPrice, OD.Quantity, OD.Discount
FROM Northwind.dbo.[Order Details] AS OD
WHERE OD.Quantity > 4


--Prikazati sve proizvode koji počinju sa slovom a ili c a trenutno nisu raspoloživi. 
SELECT* 
FROM IB200262.dbo.Proizvodi AS P
WHERE P.Naziv LIKE '[ac]%' AND P.Raspolozivost = 0
--------------------------------------------------------
--Prikazati narudžbe koje su kreirane 1996 godine i čija ukupna vrijednost je veća od 500KM. 
SELECT* 
FROM IB200262.dbo.Narudzbe AS N
JOIN IB200262.dbo.StavkeNarudzbe AS SN ON SN.NarudzbaID = N.NarudzbaID
WHERE YEAR(N.DatumNarudzbe) = 1996 AND (SN.Cijena * SN.Kolicina) > 500
--------------------------------------------------------
--Prikazati ukupni promet (uzimajući u obzir i popust) od narudžbi po teritorijama. (AdventureWorks2017) 
SELECT ST.TerritoryID, SUM(SOD.OrderQty * SOD.UnitPriceDiscount) 'Ukupni promet sa popustom'
FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD
JOIN AdventureWorks2017.Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN AdventureWorks2017.Sales.SalesTerritory AS ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.TerritoryID
---------------------------------------------------------
/*
Napisati upit koji će prikazati sljedeće podatke o proizvodima: ID proizvoda, naziv proizvoda, šifru proizvoda, te novokreiranu šifru proizvoda. (AdventureWorks2017) 
Nova šifra se sastoji od sljedećih vrijednosti: 
Svi karakteri nakon prvog znaka - (crtica) 
Karakter / 
ID proizvoda 
Npr. Za proizvod sa ID-om 716 i šifrom LJ-0192-X, nova šifra će biti 0192-X/716. 
*/

SELECT P.ProductID, P.Name, P.ProductNumber, 
SUBSTRING(P.ProductNumber, CHARINDEX('-', P.ProductNumber) + 1, LEN(P.ProductNumber)) + '/' + CAST(P.ProductID AS NVARCHAR)
FROM AdventureWorks2017.Production.Product AS P
WHERE P.ProductID = 716

/*
Kreirati proceduru sp_search_proizvodi kojom će se u tabeli Proizvodi uraditi pretraga proizvoda prema nazivu prizvoda ili nazivu dobavljača. Pretraga treba da radi i prilikom 
unosa bilo kojeg od slova, ne samo potpune riječi. Ukoliko korisnik ne unese ništa od navedenog vratiti sve zapise. Proceduru obavezno pokrenuti. 
*/
GO

CREATE PROCEDURE sp_search_proizvodi @Naziv NVARCHAR(40) = NULL, @NazivKompanijeDobavljaca NVARCHAR(40) = NULL
AS
BEGIN

SELECT*
FROM Proizvodi AS P
WHERE P.Naziv LIKE @Naziv + '%' OR P.NazivKompanijeDobavljaca LIKE @NazivKompanijeDobavljaca + '%'
END

GO

exec sp_search_proizvodi @Naziv = 'C', @NazivKompanijeDobavljaca = 'E'

/*
Kreirati proceduru sp_insert_stavkeNarudzbe koje će vršiti insert nove stavke narudžbe u tabelu stavkeNarudzbe. Proceduru obavezno pokrenuti. 
*/
GO
CREATE PROCEDURE sp_insert_stavkeNarudzbe 
(
@NarudzbaID INT, 
@ProizvodID INT,
@Cijena MONEY,
@Kolicina SMALLINT,
@Popust REAL
)
AS
BEGIN

INSERT INTO StavkeNarudzbe(NarudzbaID, ProizvodID, Cijena, Kolicina, Popust)
VALUES(@NarudzbaID, @ProizvodID, @Cijena, @Kolicina, @Popust)

END
GO

exec sp_insert_stavkeNarudzbe @NarudzbaID = 10248, @ProizvodID = 1, @Cijena = 123456, @Kolicina = 12, @Popust = 0.33


/*
Kreirati view koji prikazuje sljedeće kolone: ID narudžbe, datum narudžbe, spojeno ime i prezime kupca i ukupnu vrijednost narudžbe. Podatke sortirati prema ukupnoj 
vrijednosti u opadajućem redoslijedu. (AdventureWorks2017)
*/

GO

CREATE VIEW	view_bezimetak AS
SELECT SOD.SalesOrderID, SOH.OrderDate, P.FirstName + ' ' + P.LastName 'Ime i prezime', SOD.OrderQty * SOD.UnitPrice 'Ukupna vrijednost'
FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD
JOIN AdventureWorks2017.Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN AdventureWorks2017.Sales.Customer AS C ON C.CustomerID = SOH.CustomerID
JOIN AdventureWorks2017.Person.Person AS P ON P.BusinessEntityID = C.CustomerID
GO