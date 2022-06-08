----------------------------
--1.
----------------------------
/*
Kreirati bazu pod vlastitim brojem indeksa
*/

CREATE DATABASE IB200262
USE IB200262
GO
-----------------------------------------------------------------------
--Prilikom kreiranja tabela voditi računa o njihovom međusobnom odnosu.
-----------------------------------------------------------------------
/*
a) 
Kreirati tabelu dobavljac sljedeće strukture:
	- dobavljac_id - cjelobrojna vrijednost, primarni ključ
	- dobavljac_br_rac - 50 unicode karaktera
	- naziv_dobavljaca - 50 unicode karaktera
	- kred_rejting - cjelobrojna vrijednost
*/

CREATE TABLE Dobavljac 
(
dobavljac_id INT PRIMARY KEY,
dobavljac_br_rac NVARCHAR(50),
naziv_dobavljaca NVARCHAR(50),
kred_rejting INT
)

/*
b)
Kreirati tabelu narudzba sljedeće strukture:
	- narudzba_id - cjelobrojna vrijednost, primarni ključ
	- narudzba_detalj_id - cjelobrojna vrijednost, primarni ključ
	- dobavljac_id - cjelobrojna vrijednost
	- dtm_narudzbe - datumska vrijednost
	- naruc_kolicina - cjelobrojna vrijednost
	- cijena_proizvoda - novčana vrijednost
*/

CREATE TABLE Narudzba 
(
narudzba_id INT,
narudzba_detalj_id INT
CONSTRAINT PK_Narudzba PRIMARY KEY(narudzba_id, narudzba_detalj_id),
dobavljac_id INT CONSTRAINT FK_Narudzba_Dobavljac FOREIGN KEY REFERENCES Dobavljac(dobavljac_id),
dtm_narudzbe DATE,
naruc_kolicina INT,
cijena_proizvoda MONEY
)

/*
c)
Kreirati tabelu dobavljac_proizvod sljedeće strukture:
	- proizvod_id cjelobrojna vrijednost, primarni ključ
	- dobavljac_id cjelobrojna vrijednost, primarni ključ
	- proiz_naziv 50 unicode karaktera
	- serij_oznaka_proiz 50 unicode karaktera
	- razlika_min_max cjelobrojna vrijednost
	- razlika_max_narudzba cjelobrojna vrijednost
*/
--10 bodova

CREATE TABLE dobavljac_proizvod 
(
proizvod_id INT,
dobavljac_id INT CONSTRAINT FK_dobavljacProizvod_dobavljac FOREIGN KEY REFERENCES Dobavljac(dobavljac_id),
CONSTRAINT PK_dobavljac_proizvod PRIMARY KEY(proizvod_id, dobavljac_id),
proiz_naziv NVARCHAR(50),
serij_oznaka_proiz NVARCHAR(50),
razlika_min_max INT,
razlika_max_narudzba INT
)

----------------------------
--2. Insert podataka
----------------------------
/*
a) 
U tabelu dobavljac izvršiti insert podataka iz tabele Purchasing.Vendor prema sljedećoj strukturi:
	BusinessEntityID -> dobavljac_id 
	AccountNumber -> dobavljac_br_rac 
	Name -> naziv_dobavljaca
	CreditRating -> kred_rejting
*/
INSERT INTO Dobavljac(dobavljac_id, dobavljac_br_rac,naziv_dobavljaca, kred_rejting)
SELECT BusinessEntityID, AccountNumber,Name,CreditRating
FROM AdventureWorks2017.Purchasing.Vendor


/*
b) 
U tabelu narudzba izvršiti insert podataka iz tabela Purchasing.PurchaseOrderHeader i Purchasing.
PurchaseOrderDetail prema sljedećoj strukturi:
	PurchaseOrderID -> narudzba_id
	PurchaseOrderDetailID -> narudzba_detalj_id
	VendorID -> dobavljac_id 
	OrderDate -> dtm_narudzbe 
	OrderQty -> naruc_kolicina 
	UnitPrice -> cijena_proizvoda
*/
INSERT INTO Narudzba(narudzba_id, narudzba_detalj_id, dobavljac_id, dtm_narudzbe, naruc_kolicina, cijena_proizvoda)
SELECT POD.PurchaseOrderID, POD.PurchaseOrderDetailID, POH.VendorID, POH.OrderDate, POD.OrderQty, POD.UnitPrice
FROM AdventureWorks2017.Purchasing.PurchaseOrderDetail AS POD
INNER JOIN AdventureWorks2017.Purchasing.PurchaseOrderHeader AS POH ON POH.PurchaseOrderID = POD.PurchaseOrderID

/*
c) 
U tabelu dobavljac_proizvod izvršiti insert podataka iz tabela Purchasing.ProductVendor i 
Production.Product prema sljedećoj strukturi:
	ProductID -> proizvod_id 
	BusinessEntityID -> dobavljac_id 
	Name -> proiz_naziv 
	ProductNumber -> serij_oznaka_proiz
	MaxOrderQty - MinOrderQty -> razlika_min_max 
	MaxOrderQty - OnOrderQty -> razlika_max_narudzba
uz uslov da se povuku samo oni zapisi u kojima ProductSubcategoryID nije NULL vrijednost.
*/
--10 bodova
INSERT INTO dobavljac_proizvod( proizvod_id, dobavljac_id, proiz_naziv, serij_oznaka_proiz, razlika_min_max, razlika_max_narudzba)
SELECT PV.ProductID, PV.BusinessEntityID, P.Name, P.ProductNumber, PV.MaxOrderQty - PV.MinOrderQty 'razlika_min_max', PV.MaxOrderQty - PV.OnOrderQty 'razlika_max_narudzba'
FROM AdventureWorks2017.Purchasing.ProductVendor AS PV
INNER JOIN AdventureWorks2017.Production.Product AS P ON P.ProductID = PV.ProductID
WHERE P.ProductSubcategoryID IS NOT NULL

----------------------------
--3.
----------------------------
/*
Koristeći sve tri tabele iz vlastite baze kreirati pogled view_dob_god sljedeće strukture:
	- dobavljac_id
	- proizvod_id
	- naruc_kolicina
	- cijena_proizvoda
	- ukupno, kao proizvod naručene količine i cijene proizvoda
Uslov je da se dohvate samo oni zapisi u kojima je narudžba obavljena 2013. ili 2014. godine i da se 
broj računa dobavljača završava cifrom 1.
*/
--10 bodova
GO
CREATE VIEW view_dob_god AS
SELECT D.dobavljac_id, DP.proizvod_id, N.naruc_kolicina, N.cijena_proizvoda, N.naruc_kolicina * N.cijena_proizvoda 'Ukupno'
FROM Dobavljac AS D
INNER JOIN dobavljac_proizvod AS DP ON DP.dobavljac_id = D.dobavljac_id
INNER JOIN Narudzba AS N ON N.dobavljac_id = DP.dobavljac_id
WHERE YEAR(N.dtm_narudzbe) = 2014 OR YEAR(N.dtm_narudzbe) = 2014  
GO
----------------------------
--4.
---------------------------
/*
Koristeći pogled view_dob_god kreirati proceduru proc_dob_god koja će sadržavati parametar naruc_kolicina i imati sljedeću strukturu:
	- dobavljac_id
	- proizvod_id
	- suma_ukupno, sumirana vrijednost kolone ukupno po dobavljac_id i proizvod_id
Uslov je da se dohvataju samo oni zapisi u kojima je naručena količina trocifreni broj.
Nakon kreiranja pokrenuti proceduru za vrijednost naručene količine 300.
*/
--10 bodova
GO
CREATE PROCEDURE proc_dob_god @naruc_kolicina INT
AS
SELECT dobavljac_id, proizvod_id, SUM(proizvod_id)
FROM view_dob_god
WHERE naruc_kolicina = @naruc_kolicina
GROUP BY dobavljac_id, proizvod_id
GO

EXEC proc_dob_god 300
----------------------------
--5.
----------------------------
/*
a)
Tabelu dobavljac_proizvod kopirati u tabelu dobavljac_proizvod_nova.
b) 
Iz tabele dobavljac_proizvod_nova izbrisati kolonu razlika_min_max.
c)
U tabeli dobavljac_proizvod_nova kreirati novu kolonu razlika. Kolonu popuniti razlikom vrijednosti kolone 
razlika_max_narudzba i srednje vrijednosti ove kolone, uz uslov da ako se u zapisu nalazi NULL vrijednost 
u kolonu razlika smjestiti 0.
*/
--15 bodova


----------------------------
--6.
----------------------------
/*
Prebrojati koliko u tabeli dobavljac_proizvod ima različitih serijskih oznaka proizvoda koje završavaju bilo kojim slovom engleskog alfabeta, 
a koliko ima onih koji ne završavaju bilo kojim slovom engleskog alfabeta. Upit treba da vrati poruke:
	'Različitih serijskih oznaka proizvoda koje završavaju slovom engleskog alfabeta ima:' iza čega slijedi broj zapisa 
	i
	'Različitih serijskih oznaka proizvoda koje NE završavaju slovom engleskog alfabeta ima:' iza čega slijedi broj zapisa
*/
--10 bodova


----------------------------
--7.
----------------------------
/*
a)
Dati informaciju o dužinama podatka u koloni serij_oznaka_proiz tabele dobavljac_proizvod. 
b)
Dati informaciju o broju različitih dužina podataka u koloni serij_oznaka_proiz tabele dobavljac_proizvod. 
Poruka treba biti u obliku: 'Kolona serij_oznaka_proiz ima ___ različite dužinr podataka.
' Na mjestu donje crte se nalazi izračunati brojčani podatak.
*/
--10 bodova


----------------------------
--8.
----------------------------
/*
Prebrojati kod kolikog broja dobavljača je broj računa kreiran korištenjem više od jedne riječi iz naziva dobavljača. 
Jednom riječi se podrazumijeva skup slova koji nije prekinut blank (space) znakom. 
*/
--10 bodova

----------------------------
--9.
----------------------------
/*
Koristeći pogled view_dob_god kreirati proceduru proc_djeljivi koja će sadržavati parametar prebrojano i kojom će se prebrojati 
broj pojavljivanja vrijednosti u koloni naruc_kolicina koje su djeljive sa 100. Sortirati po koloni prebrojano. 
Nakon kreiranja pokrenuti proceduru za sljedeću vrijednost parametra prebrojano = 10
*/
--13 bodova


----------------------------
--10.
----------------------------
/*
a) Kreirati backup baze na default lokaciju.
b) Napisati kod kojim će biti moguće obrisati bazu.
c) Izvršiti restore baze.
Uslov prihvatanja kodova je da se mogu pokrenuti.
*/
--2 boda