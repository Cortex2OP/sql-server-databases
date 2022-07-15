--1.	Koristeæi bazu Northwind izdvojiti godinu, mjesec i dan datuma isporuke narudžbe.
SELECT YEAR(O.ShippedDate) AS Godina, MONTH(O.ShippedDate) AS Mjesec, DAY(O.ShippedDate) AS Dan
FROM Northwind.dbo.Orders AS O
--2.	Koristeæi bazu Northwind izraèunati koliko je vremena prošlo od datum narudžbe do danas.
USE Northwind
SELECT DATEDIFF(YEAR,O.OrderDate,GETDATE()) AS 'Broj godina'
FROM Orders AS O
--3.	Koristeæi bazu Northwind dohvatiti sve zapise u kojima ime zaposlenika poèinje slovom A.
SELECT*
FROM Employees AS E
WHERE E.FirstName LIKE 'A%'
--4.	Koristeæi bazu Pubs dohvatiti sve zapise u kojima ime zaposlenika poèinje slovom A ili M.
SELECT*
FROM pubs.dbo.employee AS E
WHERE E.fname LIKE 'A%' OR E.fname LIKE 'M%'

--%	Represents zero or more characters	bl% finds bl, black, blue, and blob
--_	Represents a single character	h_t finds hot, hat, and hit
--[]	Represents any single character within the brackets	h[oa]t finds hot and hat, but not hit
--^	Represents any character not in the brackets	h[^oa]t finds hit, but not hot and hat
---	Represents any single character within the specified range	c[a-b]t finds cat and cbt
SELECT*
FROM pubs.dbo.employee AS E
WHERE E.fname LIKE '[AM]%'

--5.	Koristeæi bazu Northwind prikazati sve kupce koje u koloni ContactTitle sadrže pojam "manager".
SELECT*
FROM Customers AS C
WHERE C.ContactTitle LIKE '%manager%'
--6.	Koristeæi bazu Northwind dohvatiti sve kupce kod kojih se poštanski broj sastoji samo od cifara. 
SELECT*
FROM Customers AS C
WHERE C.PostalCode LIKE '[0-9]%' AND C.PostalCode NOT LIKE '%-%'

SELECT*
FROM Customers AS C
WHERE C.PostalCode NOT LIKE '%[^0-9]%'

SELECT*
FROM Customers AS C
WHERE ISNUMERIC(C.PostalCode)=1

--7.	Iz tabele Person.Person baze AdventureWorks2017 u bazu Vjezba2 u tabelu Osoba kopirati kolone FirstName, MiddleName i LastName. Prikazati spojeno ime, srednje ime i prezime.Uslov je da se izmeðu pojedinih segmenata nalazi space. Omoguæiti prikaz podataka i ako neki od podataka nije unijet. Prikazati samo jedinstvene zapise (bez ponavljanja istih zapisa).

USE Vjezba2

SELECT PP.FirstName,PP.MiddleName,PP.LastName
INTO Osoba
FROM AdventureWorks2017.Person.Person AS PP

SELECT O.FirstName + ' ' +ISNULL(O.MiddleName,' ')+ ' ' + O.LastName
FROM Osoba AS O

UPDATE Osoba
SET MiddleName=' '
WHERE MiddleName IS NULL

SELECT DISTINCT O.FirstName + ' ' + O.MiddleName + ' ' + O.LastName
FROM Osoba AS O

SELECT DISTINCT CONCAT(PP.FirstName,' ',PP.MiddleName,' ',PP.LastName)
FROM AdventureWorks2017.Person.Person AS PP

--8.	Prikazati listu zaposlenika sa sljedeæim atributima: ID, ime, prezime, država i titula, gdje je ID = 9 ili dolaze iz USA. 
SELECT E.EmployeeID,E.FirstName,E.LastName,E.Country,E.Title
FROM Northwind.dbo.Employees AS E
WHERE E.EmployeeID=9 OR E.Country LIKE 'USA'
--WHERE 
--9.	 Prikazati podatke o narudžbama koje su napravljene prije 19.07.1996. godine. Izlaz treba da sadrži sljedeæe kolone: ID narudžbe, datum narudžbe, ID kupca, te grad. 
USE Northwind
SELECT O.OrderID,O.OrderDate,O.CustomerID,O.ShipCity
FROM Orders AS O
WHERE O.OrderDate<'1996-07-19'
--10.	Prikazati stavke narudžbe gdje je kolièina narudžbe bila veæa od 100 komada uz odobreni popust.
SELECT*
FROM [Order Details] AS OD
WHERE OD.Quantity>100 AND OD.Discount>0
--11.	 Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rijeè „Restaurant“. Ukoliko naziv kompanije sadrži karakter (-), kupce izbaciti iz rezultata upita. 
SELECT C.CompanyName,C.Phone
FROM Customers AS C
WHERE C.CompanyName LIKE '%Restaurant%' AND C.CompanyName NOT LIKE '%-%'
--12.	 Prikazati proizvode èiji naziv poèinje slovima „C“ ili „G“, drugo slovo može biti bilo koje, a treæe slovo u nazivu je „A“ ili „O“. 
SELECT*
FROM Products AS P
WHERE P.ProductName LIKE '[CG]_[ao]%'
--13.	Prikazati listu proizvoda èiji naziv poèinje slovima „L“ ili „T“, ili je ID proizvoda = 46. Lista treba da sadrži samo one proizvode èija se cijena po komadu kreæe izmeðu 10 i 50 (ukljuèujuæi graniène vrijednosti). Upit napisati na dva naèina. 
SELECT *
FROM Products AS P
WHERE (P.ProductName LIKE '[LT]%' OR P.ProductID=46) AND P.UnitPrice BETWEEN 10 AND 50

SELECT *
FROM Products AS P
WHERE (P.ProductName LIKE '[LT]%' OR P.ProductID=46) AND P.UnitPrice>=10 AND P.UnitPrice<=50

--14.	Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naruèene kolièine. Takoðer, u rezultate upita ukljuèiti razliku izmeðu naruèene kolièine i stanja zaliha. 
SELECT P.ProductName,P.UnitPrice,P.UnitsInStock-P.UnitsOnOrder AS Razlika
FROM Products AS P
WHERE P.UnitsInStock<P.UnitsOnOrder
--15.	Prikazati dobavljaèe koji dolaze iz Španije ili Njemaèke a nemaju unesen broj faxa. Formatirati izlaz NULL vrijednosti. Upit napisati na dva naèina
SELECT S.SupplierID,S.CompanyName,S.ContactName,S.ContactTitle,S.Address,S.City,S.Region,S.PostalCode,S.Country,S.Phone,ISNULL(S.Fax,'nepoznata vrijednost') AS Fax,S.HomePage
FROM Suppliers AS S
WHERE S.Country IN ('Spain','Germany') AND S.Fax IS NULL

SELECT S.SupplierID,S.CompanyName,S.ContactName,S.ContactTitle,S.Address,S.City,S.Region,S.PostalCode,S.Country,S.Phone,ISNULL(S.Fax,'nepoznata vrijednost') AS Fax,S.HomePage
FROM Suppliers AS S
WHERE (S.Country LIKE'Spain'OR S.Country LIKE'Germany') AND S.Fax IS NULL

--16.	Prikazati listu autora sa sljedeæim kolonama: ID, ime i prezime (spojeno), grad i to samo one autore èiji ID poèinje brojem 8 ili dolaze iz grada „Salt Lake City“. Takoðer autorima status ugovora treba biti 1. Koristiti aliase nad kolonama.
USE pubs
SELECT A.au_id, A.au_fname +' '+A.au_lname AS 'ime prezime', A.city,A.contract
FROM authors AS A
WHERE (A.au_id LIKE '8%' OR A.city LIKE 'Salt Lake City') AND A.contract=1
--17.	Prikazati sve tipove knjiga bez duplikata. Listu sortirati po tipu. 
SELECT DISTINCT T.type
FROM titles AS T
ORDER BY T.type
--18.	Prikazati listu prodaje knjiga sa sljedeæim kolonama: ID prodavnice, broj narudžbe i kolièinu, ali samo gdje je kolièina izmeðu 10 i 50, ukljuèujuæi i graniène vrijednosti. Rezultat upita sortirati po kolièini opadajuæim redoslijedom. Upit napisati na dva naèina.
SELECT S.stor_id,S.ord_num,S.qty AS Kolicina
FROM sales AS S
WHERE S.qty BETWEEN 10 AND 50
ORDER BY 3 DESC
--19.	Prikazati listu knjiga sa sljedeæim kolonama: naslov, tip djela i cijenu. Kao novu kolonu dodati 20% od prikazane cijene (npr. Ako je cijena 19.99 u novoj koloni treba da piše 3,998). Naziv kolone se treba zvati „20% od cijene“. Listu sortirati abecedno po tipu djela i po cijeni opadajuæim redoslijedom. Sa liste eliminisati one vrijednosti koje u polju cijena imaju nepoznatu vrijednost. Modifikovati upit tako da prikaže cijenu umanjenu za 20 %. Naziv kolone treba da se zove „Cijena umanjena za 20%“. 
SELECT T.title,T.type,T.price,T.price*0.2 '20% od cijene', T.price*(1-0.2)'Cijena umanjena za 20%'
FROM titles AS T
WHERE T.price IS NOT NULL
ORDER BY 2,3
--20.	Prikazati 10 kolièinski najveæih stavki prodaje. Lista treba da sadrži broj narudžbe, datum narudžbe i kolièinu. Provjeriti da li ima više stavki sa kolièinom kao posljednja u listi
USE pubs
SELECT TOP 10 WITH TIES S.ord_num,S.ord_date,S.qty
FROM sales AS S
ORDER BY 3 DESC




