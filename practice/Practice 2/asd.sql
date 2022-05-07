--Kroz SQL kod kreirati bazu podataka Vjezba2
CREATE DATABASE Vjezba2
GO
USE Vjezba2
--2. U pomenutoj bazi kreirati šemu Prodaja
GO	
CREATE SCHEMA Prodaja
GO
--3. U šemi Prodaja kreirati tabele sa sljedećom strukturom:
--Autori
-- AutorID, 11 karaktera i primarni ključ
-- Prezime, 40 karaktera (obavezan unos)
-- Ime, 20 karaktera (obavezan unos)
-- Telefon, 12 karaktera fiksne dužine, zadana vrijednost „nepoznato“
-- Adresa, 40 karaktera
-- Drzava, 2 karaktera fiksne dužine
-- PostanskiBroj, 5 karaktera fiksne dužine
-- Ugovor, bit polje (obavezan unos)
CREATE TABLE Prodaja.Autori 
(
AutorID VARCHAR(11) CONSTRAINT PK_Autor PRIMARY KEY,
Prezime VARCHAR(40) NOT NULL,
Ime VARCHAR(20) NOT NULL,
Telefon CHAR(12) DEFAULT 'NEPOZNATO',
Adresa VARCHAR(40),
Drzava CHAR(2),
PostanskiBroj CHAR(5),
Ugovor BIT NOT NULL
)
--Knjige
-- KnjigaID, 6 karaktera i primarni ključ
-- Naziv, 80 karaktera (obavezan unos)
-- Vrsta, 12 karaktera fiksne dužine (obavezan unos)
-- IzdavacID, 4 karaktera fiksne duzine
-- Cijena, novčani tip podatka
-- Biljeska, 200 karaktera
-- Datum, datumsko-vremenski tip
CREATE TABLE Prodaja.Knjige 
(
KnjigaID VARCHAR(6) CONSTRAINT PK_Knjiga PRIMARY KEY,
Naziv VARCHAR(80) NOT NULL,
Vrsta CHAR(12) NOT NULL,
IzdavacID CHAR(4),
Cijena MONEY,
Biljeska VARCHAR(200),
Datum DATETIME
)
--4. Upotrebom insert naredbe iz tabele Publishers baze Pubs izvršiti kreiranje i insertovanje
--podataka u tabelu Izdavaci šeme Prodaja
SELECT *
INTO Prodaja.Izdavaci
FROM pubs.dbo.publishers
--5. U kreiranoj tabeli Izdavaci provjeriti koje polje je primarni ključ
ALTER TABLE Prodaja.Izdavaci
ADD CONSTRAINT PK_Izdavac PRIMARY KEY(pub_id)
--6. Povezati tabelu Izdavaci sa tabelom Knjige
ALTER TABLE Prodaja.Knjige
ADD CONSTRAINT FK_Knjiga_Izdavac FOREIGN KEY(IzdavacID) REFERENCES Prodaja.Izdavaci(pub_id)
--7. U šemu Prodaja dodati tabelu sa sljedećom strukturom
--AutoriKnjige
-- AutorID 11 karaktera, spoljni ključ
-- KnjigaID 6 karaktera, spoljni ključ
-- AuOrd kratki cjelobrojni tip podatka
-- **Definisati primarni ključ
CREATE TABLE Prodaja.AutoriKnjige 
(
AutorID VARCHAR(11) CONSTRAINT FK_AutoriKnjige_Autori FOREIGN KEY REFERENCES Prodaja.Autori(AutorID),
KnjigaID VARCHAR(6) CONSTRAINT FK_AutoriKnjige_Knjige FOREIGN KEY REFERENCES Prodaja.Knjige(KnjigaID),
AuOrd TINYINT
CONSTRAINT PK_AutoriKnjige PRIMARY KEY(AutorID, KnjigaID)
)
--8. U kreirane tabele izvršiti insert podataka iz baze Pubs (Za polje biljeska tabele Knjige na
--mjestima gdje je vrijednost NULL pohraniti „nepoznata vrijednost“)
INSERT INTO Prodaja.Autori
SELECT A.au_id, A.au_lname, A.au_fname, A.phone, A.address, A.state, A.zip, A.contract
FROM pubs.dbo.authors AS A
-------------------------------------------
INSERT INTO Prodaja.Knjige
SELECT t.title_id, t.title, t.type, t.pub_id, t.price, ISNULL(t.notes, 'NEPOZNATA VRIJEDNOST'), t.pubdate
FROM pubs.dbo.titles AS t
-------------------------------------------
INSERT INTO Prodaja.AutoriKnjige
SELECT A.au_id, A.title_id, A.au_ord
FROM pubs.dbo.titleauthor AS A
--9. U tabeli Autori nad kolonom Adresa promijeniti tip podatka na nvarchar (40)
ALTER TABLE Prodaja.Autori
ALTER COLUMN Adresa NVARCHAR(40)
--10. Prikazati sve autore čije ime počinje sa slovom A ili S
SELECT A.Ime
FROM Prodaja.Autori AS A
WHERE A.Ime LIKE 'A%' OR A.Ime LIKE 'S%'
--11. Prikazati knjige gdje cijena nije unesena
SELECT *
FROM Prodaja.Knjige AS A
WHERE A.Cijena IS NULL
--12. U bazi Vjezba2 kreirati šemu Narudzbe
GO
CREATE SCHEMA Narudzbe
GO
--13. Upotrebom insert naredbe iz tabele Region baze Northwind izvršiti kreiranje i insertovanje
--podataka u tabelu Regije šeme Narudžbe
SELECT *
INTO Narudzbe.Regije
FROM Northwind.dbo.Region
--14. Prikazati sve podatke koji se nalaze u tabeli Regije
SELECT * 
FROM Narudzbe.Regije
--15. U tabelu Regije insertovati zapis:
--   5 SEINSERT INTO Narudzbe.RegijeVALUES(5, 'SE')--16. U tabelu Regije insertovati zapise:
--6 NE
--7 NWINSERT INTO Narudzbe.RegijeVALUES(6, 'NE'), (7, 'NW')--17. Upotrebom insert naredbe iz tabele OrderDetails baze Northwind izvršiti kreiranje i
--insertovanje podataka u tabelu StavkeNarudzbe šeme NarudzbeSELECT *INTO Narudzbe.StavkeNarudzbeFROM Northwind.dbo.[Order Details]--18. U tabeli StavkeNarudzbe dodati standardnu kolonu ukupno tipa decimalni broj (8,2).ALTER TABLE Narudzbe.StavkeNarudzbeADD Ukupno DECIMAL(8,2)UPDATE Narudzbe.StavkeNarudzbeSET Ukupno = Quantity*UnitPrice--20. U tabeli StavkeNarduzbe dodati izračunatu kolonu CijeliDio u kojoj će biti cijeli dio iz kolone UnitPriceALTER TABLE Narudzbe.StavkeNarudzbeADD CijeliDio AS FLOOR(UnitPrice)--21. U tabeli StavkeNarduzbe kreirati ograničenje na koloni Discount kojim će se onemogućiti unos
--vrijednosti manjih od 0.
ALTER TABLE Narudzbe.StavkeNarudzbe
ADD CONSTRAINT CK_Discount CHECK(Discount>=0)