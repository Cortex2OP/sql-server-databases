/*
Vježba 4 :: Zadaci
1. Iz tabele HumanResources.Employee baze AdventureWorks2017 iz kolone LoginID
izvući ime uposlenika.
*/
SELECT E.LoginID, SUBSTRING(E.LoginID,CHARINDEX('\',E.LoginID)+1,LEN(E.LoginID)-CHARINDEX('\',E.LoginID)-1) AS 'Ime uposlenika'
FROM AdventureWorks2017.HumanResources.Employee AS E
/*
2. Kreirati upit koji prikazuje podatke o zaposlenicima. Lista treba da sadrži sljedeće
kolone: ID uposlenika, korisničko ime i novu lozinku:
Uslovi su sljedeći:
 Za korisničko ime potrebno je koristiti kolonu LoginID (tabela Employees).
Npr. LoginID zaposlenika sa imenom i prezimenom 'Mary Gibson' je
adventureworks\mary0. Korisničko ime zaposlenika je sve što se nalazi iza
znaka \ (backslash) što je u ovom primjeru mary0,
 Nova lozinka se formira koristeći Rowguid zaposlenika na sljedeći način:
Rowguid je potrebno okrenuti obrnuto (npr. dbms2015 -> 5102smbd) i nakon
toga preskačemo prvih 5 i uzimamo narednih 8 karaktera
 Sljedeći korak jeste da iz dobivenog stringa počevši od drugog karaktera
naredna dva zamijenimo sa X# (npr. ako je dobiveni string dbms2015 izlaz će
biti dX#s2015)
3. Iz tabele Sales.Customer baze AdventureWorks2017 iz kolone AccountNumber izvući
broj pri čemu je potrebno broj prikazati bez vodećih nula.
a) dohvatiti sve zapise
b) dohvatiti one zapise kojima je unijet podatak u kolonu PersonID
4. Iz tabele Purchasing.Vendor baze AdventureWorks2017 dohvatiti zapise u kojima se
podatak u koloni AccountNumber formirao iz prve riječi kolone Name.
5. Koristeći bazu Northwind kreirati upit koji će prikazati odvojeno ime i prezime, naziv
firme te državu i grad kupca ali samo onih čija adresa završava sa 2 ili više broja (uzeti
u obzir samo one kupce koji u polju ContactName imaju dvije riječi).
6. Koristeći bazu Northwind u tabeli Customers dodati izračunato polje Spol u koji će se
upitom pohraniti vrijednost da li se radi o muškarcu ili ženi (M ili F). Vrijednost na
osnovu koje se određuje to o kojem se spolu radi nalazi se u koloni ContactName gdje
zadnje slovo prve riječi određuje spol (riječi koje se završavaju slovom a predstavljaju
osobe ženskog spola).
*/