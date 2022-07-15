/*
1. Kroz SQL kod kreirati bazu podataka Vjezba2
*/
CREATE DATABASE Vjezba2
GO
USE Vjezba2
/*
2. U pomenutoj bazi kreirati šemu Prodaja
*/
CREATE SCHEMA Prodaja
/*
3. U šemi Prodaja kreirati tabele sa sljedećom strukturom:
Autori
 AutorID, 11 karaktera i primarni ključ
 Prezime, 40 karaktera (obavezan unos)
 Ime, 20 karaktera (obavezan unos)
 Telefon, 12 karaktera fiksne dužine, zadana vrijednost „nepoznato“
 Adresa, 40 karaktera
 Drzava, 2 karaktera fiksne dužine
 PostanskiBroj, 5 karaktera fiksne dužine
 Ugovor, bit polje (obavezan unos)
*/
CREATE TABLE Prodaja.Autori (
AutorID VARCHAR(11) CONSTRAINT PK_Autori PRIMARY KEY,
Prezime VARCHAR(40) NOT NULL,
Ime VARCHAR(20) NOT NULL,
Telefon CHAR(12) DEFAULT('nepoznato'),
Adresa VARCHAR(40),
Drzava CHAR(2),
PostanskiBroj CHAR(5),
Ugovor BIT NOT NULL
)
/*
Knjige
 KnjigaID, 6 karaktera i primarni ključ
 Naziv, 80 karaktera (obavezan unos)
 Vrsta, 12 karaktera fiksne dužine (obavezan unos)
 IzdavacID, 4 karaktera fiksne duzine
 Cijena, novčani tip podatka
 Biljeska, 200 karaktera
 Datum, datumsko-vremenski tip
*/
CREATE TABLE Knjige (
KnjigaID VARCHAR(6) CONSTRAINT PK_Knjige PRIMARY KEY,
Naziv VARCHAR(80) NOT NULL,
Vrsta CHAR(12) NOT NULL,
IzdavacID CHAR(4),
Cijena MONEY,
Biljeska VARCHAR(200),
Datum DATETIME
)
/*
4. Upotrebom insert naredbe iz tabele Publishers baze Pubs izvršiti kreiranje i insertovanje
podataka u tabelu Izdavaci šeme Prodaja
*/
SELECT*
INTO Prodaja.Izdavaci
FROM pubs.dbo.publishers
/*
5. U kreiranoj tabeli Izdavaci provjeriti koje polje je primarni ključ
*/
ALTER TABLE Prodaja.Izdavaci 
ADD CONSTRAINT PK_Izdavaci PRIMARY KEY(pub_id)
/*
6. Povezati tabelu Izdavaci sa tabelom Knjige
7. U šemu Prodaja dodati tabelu sa sljedećom strukturom
AutoriKnjige
 AutorID 11 karaktera, spoljni ključ
 KnjigaID 6 karaktera, spoljni ključ
 AuOrd kratki cjelobrojni tip podatka
 **Definisati primarni ključ
8. U kreirane tabele izvršiti insert podataka iz baze Pubs (Za polje biljeska tabele Knjige na
mjestima gdje je vrijednost NULL pohraniti „nepoznata vrijednost“)
9. U tabeli Autori nad kolonom Adresa promijeniti tip podatka na nvarchar (40)
10. Prikazati sve autore čije ime počinje sa slovom A ili S
11. Prikazati knjige gdje cijena nije unesena
12. U bazi Vjezba2 kreirati šemu Narudzbe
13. Upotrebom insert naredbe iz tabele Region baze Northwind izvršiti kreiranje i insertovanje
podataka u tabelu Regije šeme Narudžbe
14. Prikazati sve podatke koji se nalaze u tabeli Regije
15. U tabelu Regije insertovati zapis:
5 SE
16. U tabelu Regije insertovati zapise:
6 NE
7 NW
17. Upotrebom insert naredbe iz tabele OrderDetails baze Northwind izvršiti kreiranje i
insertovanje podataka u tabelu StavkeNarudzbe šeme Narudzbe
18. U tabeli StavkeNarudzbe dodati standardnu kolonu ukupno tipa decimalni broj (8,2).
19. Izvršiti update kreirane kolone kao umnožak kolona Quantity i UnitPrice.
20. U tabeli StavkeNarduzbe dodati izračunatu kolonu CijeliDio u kojoj će biti cijeli dio iz kolone
UnitPrice
21. U tabeli StavkeNarduzbe kreirati ograničenje na koloni Discount kojim će se onemogućiti unos
vrijednosti manjih od 0.
22. U tabelu StavkeNarudzbe insertovati novi zapis (potrebno je testirati postavljeno ograničenje)
23. U šemu Narudzbe dodati tabelu sa sljedećom strukturom:
Kategorije
 KategorijaID , cjelobrojna vrijednost, primarni ključ i autoinkrement
 ImeKategorije, 15 UNICODE znakova (obavezan unos)
 Opis, tekstualan UNICODE tip podatka
24. U kreiranu tabelu izvršiti insertovanje podataka iz tabele Categories baze Northwind
25. U tabelu Kategorije insertovati novu kategoriju pod nazivom „Ncategory“
26. Kreirati upit kojim će se prikazati sve kategorije
27. Izvršiti update zapisa u tabeli Kategorije na mjestima gdje Opis kategorije nije dodan pohraniti
vrijednost „bez opisa“
28. Izvršiti brisanje svih kategorija
*/