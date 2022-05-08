--1. Koristeći bazu Northwind izdvojiti godinu, mjesec i dan datuma isporuke narudžbe
SELECT DAY(O.ShippedDate) AS Dan, MONTH(O.ShippedDate) AS Mjesec, YEAR(O.ShippedDate) AS Godina
FROM Northwind.dbo.Orders AS O
--2. Koristeći bazu Northwind izračunati koliko je vremena prošlo od datum narudžbe do danas
SELECT DATEDIFF(YEAR, O.OrderDate, GETDATE()) as 'Broj godina'
FROM Northwind.dbo.Orders AS O
--3. Koristeći bazu Northwind dohvatiti sve zapise u kojima ime zaposlenika počinje slovom A.
SELECT *
FROM Northwind.dbo.Employees as E
WHERE E.FirstName LIKE 'A%'
--4. Koristeći bazu Pubs dohvatiti sve zapise u kojima ime zaposlenika počinje slovom A ili M.
SELECT *
FROM pubs.dbo.employee as E
WHERE E.fname LIKE 'A%' OR e.fname LIKE 'M%'
--5. Koristeći bazu Northwind prikazati sve kupce koje u koloni ContactTitle sadrže pojam "manager".SELECT *
FROM Northwind.dbo.Customers as C
WHERE C.ContactTitle LIKE '%manager%'--6. Koristeći bazu Northwind dohvatiti sve kupce kod kojih se poštanski broj sastoji samo od cifara.SELECT *
FROM Northwind.dbo.Customers as C
WHERE C.PostalCode LIKE '%[0-9]%' AND C.PostalCode NOT LIKE '%-%'--7. Iz tabele Person.Person baze AdventureWorks2017 u bazu Vjezba2 u tabelu Osoba
--kopirati kolone FirstName, MiddleName i LastName. Prikazati spojeno ime, srednje
--ime i prezime.Uslov je da se između pojedinih segmenata nalazi space. Omogućiti
--prikaz podataka i ako neki od podataka nije unijet. Prikazati samo jedinstvene zapise
--(bez ponavljanja istih zapisa).USE Vjezba2SELECT P.FirstName, P.MiddleName, P.LastNameINTO OsobaFROM AdventureWorks2017.Person.Person AS PSELECT DISTINCT O.FirstName + ' ' + ISNULL(O.MiddleName, '') + ' ' + O.LastName AS 'Ime i prezime'FROM dbo.Osoba AS O--8. Prikazati listu zaposlenika sa sljedećim atributima: ID, ime, prezime, država i titula, gdje je ID = 9 ili dolaze iz USA. SELECT *FROM Northwind.dbo.Employees AS EWHERE E.EmployeeID = 9 OR E.Country = 'USA'--9. Prikazati podatke o narudžbama koje su napravljene prije 19.07.1996. godine. Izlaz
--treba da sadrži sljedeće kolone: ID narudžbe, datum narudžbe, ID kupca, te grad. 
SELECT *
FROM Northwind.dbo.Orders as O
WHERE O.OrderDate < '1996-07-19'
--10. Prikazati stavke narudžbe gdje je količina narudžbe bila veća od 100 komada uz odobreni popust.SELECT *
FROM Northwind.dbo.[Order Details] AS O
WHERE O.Quantity > 100 AND O.Discount > 0
--11. Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu
--posjeduju riječ „Restaurant“. Ukoliko naziv kompanije sadrži karakter (-), kupce izbaciti iz rezultata upita. 
SELECT C.CompanyName, C.Phone
FROM Northwind.dbo.Customers AS C
WHERE C.CompanyName LIKE '%restaurant%' AND C.CompanyName NOT LIKE '%-%'
--12. Prikazati proizvode čiji naziv počinje slovima „C“ ili „G“, drugo slovo može biti bilo
--koje, a treće slovo u nazivu je „A“ ili „O“. 
SELECT*
FROM Northwind.dbo.Products as P
WHERE P.ProductName LIKE '[CG]_[AO]%'
--13. Prikazati listu proizvoda čiji naziv počinje slovima „L“ ili „T“, ili je ID proizvoda = 46.
--Lista treba da sadrži samo one proizvode čija se cijena po komadu kreće između 10 i
--50 (uključujući granične vrijednosti). Upit napisati na dva načina.
SELECT*
FROM Northwind.dbo.Products as P
WHERE (P.ProductName LIKE '[LT]%'  OR P.ProductID = 46) AND P.UnitPrice BETWEEN 10 AND 50 

SELECT*
FROM Northwind.dbo.Products as P
WHERE (P.ProductName LIKE '[LT]%'  OR P.ProductID = 46) AND P.UnitPrice >= 10 AND P.UnitPrice<=50
--14. Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naručene
--količine. Također, u rezultate upita uključiti razliku između naručene količine i stanja
--zaliha. 
SELECT P.ProductName, P.UnitPrice, P.UnitsInStock - P.UnitsOnOrder as Razlika
FROM Northwind.dbo.Products as P
WHERE P.UnitsInStock < P.UnitsOnOrder
--15. Prikazati dobavljače koji dolaze iz Španije ili Njemačke a nemaju unesen broj faxa.
--Formatirati izlaz NULL vrijednosti. Upit napisati na dva načinaSELECT*FROM Northwind.dbo.Suppliers AS SWHERE (S.Country LIKE 'Germany' OR S.Country LIKE 'Spain') AND S.Fax IS NULLSELECT*FROM Northwind.dbo.Suppliers AS SWHERE (S.Country LIKE 'Germany' OR S.Country LIKE 'Spain') AND S.Fax IS NULL--16. Prikazati listu autora sa sljedećim kolonama: ID, ime i prezime (spojeno), grad i to samo
--one autore čiji ID počinje brojem 8 ili dolaze iz grada „Salt Lake City“. Također
--autorima status ugovora treba biti 1. Koristiti aliase nad kolonama.SELECT A.au_id, A.au_fname + ' ' + A.au_lname AS 'Ime i Prezime', A.cityFROM pubs.dbo.authors AS AWHERE (A.au_id LIKE '8%' OR A.city LIKE 'Salt Lake City') AND A.contract = 1--17. Prikazati sve tipove knjiga bez duplikata. Listu sortirati po tipu.SELECT DISTINCT t.typeFROM pubs.dbo.titles AS TORDER BY t.type--18. Prikazati listu prodaje knjiga sa sljedećim kolonama: ID prodavnice, broj narudžbe i
--količinu, ali samo gdje je količina između 10 i 50, uključujući i granične vrijednosti.
--Rezultat upita sortirati po količini opadajućim redoslijedom. Upit napisati na dva
--načina.
SELECT S.stor_id, S.ord_num, S.qty
FROM pubs.dbo.sales AS S
WHERE S.qty BETWEEN 10 AND 50
ORDER BY qty DESC
--19. Prikazati listu knjiga sa sljedećim kolonama: naslov, tip djela i cijenu. Kao novu kolonu
--dodati 20% od prikazane cijene (npr. Ako je cijena 19.99 u novoj koloni treba da piše
--3,998). Naziv kolone se treba zvati „20% od cijene“. Listu sortirati abecedno po tipu
--djela i po cijeni opadajućim redoslijedom. Sa liste eliminisati one vrijednosti koje u
--polju cijena imaju nepoznatu vrijednost. Modifikovati upit tako da prikaže cijenu
--umanjenu za 20 %. Naziv kolone treba da se zove „Cijena umanjena za 20%“.
SELECT T.title, T.type, T.price, T.price*0.2 AS '20% od cijene'
FROM pubs.dbo.titles AS T
WHERE T.price IS NOT NULL
ORDER BY T.type, T.price
--20. Prikazati 10 količinski najvećih stavki prodaje. Lista treba da sadrži broj narudžbe,
--datum narudžbe i količinu. Provjeriti da li ima više stavki sa količinom kao  u listi
SELECT TOP 10 WITH TIES S.ord_num, S.ord_date, S.qty
FROM pubs.dbo.sales AS S
ORDER BY S.qty DESC
