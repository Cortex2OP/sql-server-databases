--FUNKCIJE ZA RAD SA STRINGOVIMA
SELECT LEFT('Softverski inzinjering',2)  --REZULTAT: SO
SELECT RIGHT('Softverski inzinjering',11)  --REZULTAT: INZINJERING
SELECT CHARINDEX(' ','Sofrverski inzinjering') --REZULTAT: 11
SELECT PATINDEX('%[0-9]%','FITCC2022') --REZULTAT 6
SELECT SUBSTRING('Sofrverski inzinjering',11+1,11) --REZULTAT: INZINJERING
SELECT UPPER('Sofrverski inzinjering') --REZULTAT: INZINJERING
SELECT LOWER('Sofrverski inzinjering') --REZULTAT: inzinjering
SELECT LEN('Sofrverski inzinjering') --REZULTAT: 22
SELECT REPLACE('Sofrverski inzinjering','i','XY') --REZULTAT:SofrverskXY XYnzXYnjerXYng
SELECT STUFF('Softverski inzinjering',3,2,'XY') --REZULTAT: SoXYverski inzinjering
SELECT STR(122)+ '.' --REZULTAT: 122.
SELECT REVERSE('Softverski inzinjering') --REZULTAT: gnirejnizni iksrevtfoS


--Vježba 4 :: Zadaci

--1.	Iz tabele HumanResources.Employee baze AdventureWorks2017 iz kolone LoginID izvuæi ime uposlenika.
SELECT E.LoginID, SUBSTRING(E.LoginID,CHARINDEX('\',E.LoginID)+1,LEN(E.LoginID)-CHARINDEX('\',E.LoginID)-1) AS 'Ime uposlenika'
FROM AdventureWorks2017.HumanResources.Employee AS E

--2.	Kreirati upit koji prikazuje podatke o zaposlenicima. Lista treba da sadrži sljedeæe kolone: ID uposlenika, korisnièko ime i novu lozinku:
--Uslovi su sljedeæi: 
--•	Za korisnièko ime potrebno je koristiti kolonu LoginID (tabela Employees). Npr. LoginID zaposlenika sa imenom i prezimenom 'Mary Gibson' je adventureworks\mary0. Korisnièko ime zaposlenika je sve što se nalazi iza znaka \ (backslash) što je u ovom primjeru mary0, 
--•	Nova lozinka se formira koristeæi hešovanu lozinku zaposlenika na sljedeæi naèin: o Hešovanu lozinku potrebno je okrenuti obrnuto (npr. dbms2015 -> 5102smbd) o Nakon toga preskaèemo prvih 5 i uzimamo narednih 8 karaktera 
--•	Sljedeæi korak jeste da iz dobivenog stringa poèevši od drugog karaktera naredna dva zamijenimo sa X# (npr. ako je dobiveni string dbms2015 izlaz æe biti dX#s2015) 
--RJEŠENJE 1 
SELECT *,RIGHT(E.LoginID,CHARINDEX('\',REVERSE(E.LoginID))-1) AS 'Korisnicko ime', 
REPLACE(SUBSTRING(REVERSE(E.rowguid),6,7),SUBSTRING(SUBSTRING(REVERSE(E.rowguid),6,8),2,3),'X#')
FROM AdventureWorks2017.HumanResources.Employee AS E
--RJEŠENJE 2
SELECT *,RIGHT(E.LoginID,CHARINDEX('\',REVERSE(E.LoginID))-1) AS 'Korisnicko ime', 
STUFF(SUBSTRING(REVERSE(E.rowguid),6,8),2,2,'X#') 'Nova lozinka'
FROM AdventureWorks2017.HumanResources.Employee AS E

--3.	Iz tabele Sales.Customer baze AdventureWorks2017 iz kolone AccountNumber izvuæi broj pri èemu je potrebno broj prikazati bez vodeæih nula.
--a) dohvatiti sve zapise
--b) dohvatiti one zapise kojima je unijet podatak u kolonu PersonID
--a
SELECT C.AccountNumber, CAST(RIGHT(C.AccountNumber,PATINDEX('%[A-Z]%',REVERSE(C.AccountNumber))-1) AS INT)
FROM AdventureWorks2017.Sales.Customer AS C
--b
SELECT C.AccountNumber, CAST(RIGHT(C.AccountNumber,PATINDEX('%[A-Z]%',REVERSE(C.AccountNumber))-1) AS INT)
FROM AdventureWorks2017.Sales.Customer AS C
WHERE C.PersonID IS NOT NULL

--4.	Iz tabele Purchasing.Vendor baze AdventureWorks2017 dohvatiti zapise u kojima se podatak u koloni AccountNumber formirao iz prve rijeèi kolone Name.
--1.RJEŠENJE
SELECT PV.AccountNumber,PV.Name,LEFT(PV.AccountNumber,CHARINDEX('0',PV.AccountNumber)-1), LEFT(PV.Name+' ',CHARINDEX(' ',PV.Name+ ' ')-1)
FROM AdventureWorks2017.Purchasing.Vendor AS PV
WHERE LEFT(PV.AccountNumber,CHARINDEX('0',PV.AccountNumber)-1)=LEFT(PV.Name+' ',CHARINDEX(' ',PV.Name+ ' ')-1)
--2.RJEŠENJE
SELECT PV.AccountNumber,PV.Name,LEFT(PV.AccountNumber,CHARINDEX('0',PV.AccountNumber)-1), IIF(CHARINDEX(' ',PV.Name)=0,PV.Name,LEFT(PV.Name,CHARINDEX(' ',PV.Name)-1))
FROM AdventureWorks2017.Purchasing.Vendor AS PV
WHERE LEFT(PV.AccountNumber,CHARINDEX('0',PV.AccountNumber)-1)=IIF(CHARINDEX(' ',PV.Name)=0,PV.Name,LEFT(PV.Name,CHARINDEX(' ',PV.Name)-1))
--3 RJEŠENJE
SELECT PV.AccountNumber,PV.Name,LEFT(PV.AccountNumber,PATINDEX('%[0-9]%',PV.AccountNumber)-1), IIF(CHARINDEX(' ',PV.Name)=0,PV.Name,LEFT(PV.Name,CHARINDEX(' ',PV.Name)-1))
FROM AdventureWorks2017.Purchasing.Vendor AS PV
WHERE LEFT(PV.AccountNumber,PATINDEX('%[0-9]%',PV.AccountNumber)-1)=IIF(CHARINDEX(' ',PV.Name)=0,PV.Name,LEFT(PV.Name,CHARINDEX(' ',PV.Name)-1))

--5.	Koristeæi bazu Northwind kreirati upit koji æe prikazati odvojeno ime i prezime, naziv firme te državu i grad kupca ali samo onih èija adresa završava sa 2 ili više cifre. U rezultate upita ne treba ukljuèiti one koje u polju ContactName imaju 2 ili više rijeèi
SELECT LEFT(C.ContactName,CHARINDEX(' ',C.ContactName)-1) AS Ime, RIGHT(C.ContactName,CHARINDEX(' ',REVERSE(C.ContactName))-1) AS Prezime, C.CompanyName ,C.ContactName,C.Address
FROM Northwind.dbo.Customers AS C
WHERE IIF(ISNUMERIC(RIGHT(C.Address,CHARINDEX(' ',REVERSE(C.Address))-1))=1,RIGHT(C.Address,CHARINDEX(' ',REVERSE(C.Address))-1),0)>=10 AND LEN(C.ContactName)-LEN(REPLACE(C.ContactName,' ',''))=1

--6.	Koristeæi bazu Northwind u tabeli Customers dodati izraèunato polje Spol u koji æe se upitom pohraniti vrijednost da li se radi o muškarcu ili ženi (M ili F). Vrijednost na osnovu koje se odreðuje to o kojem se spolu radi nalazi se u koloni ContactName gdje zadnje slovo prve rijeèi odreðuje spol (rijeèi koje se završavaju slovom a predstavljaju osobe ženskog spola).
--SELECT I PROVJERA ISPRAVNOSTI ZAPISA
SELECT C.ContactName,IIF(RIGHT(LEFT(C.ContactName,CHARINDEX(' ',C.ContactName)-1),1)='a','F','M')
FROM Northwind.dbo.Customers AS C
--COMPUTED FIELD 
ALTER TABLE Northwind.dbo.Customers
ADD Spol2 AS IIF(RIGHT(LEFT(ContactName,CHARINDEX(' ',ContactName)-1),1)='a','F','M')

