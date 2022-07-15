/*
Vježba 1 :: Zadaci
1. Kreirati bazu podataka pod nazivom ZadaciZaVjezbu.
*/
CREATE DATABASE ZadaciZaVjezbu
GO
USE ZadaciZaVjezbu
/*
2. U pomenutoj bazi kreirati tabelu Aplikanti koja će sadržavati sljedeće kolone: Ime,
Prezime i Mjesto_rođenja. Sva navedena polja trebaju da budu tekstualnog tipa, te
prilikom kreiranja istih paziti da se ne zauzimaju bespotrebno memorijski resursi.
*/
CREATE TABLE Aplikanti (
Ime NVARCHAR(10),
Prezime NVARCHAR(10),
Mjesto_rodjenja NVARCHAR(20)
)
/*
3. U tabelu Aplikanti dodati kolonu AplikantID, te je proglasiti primarnim ključem tabele
(kolona mora biti autonkrement)
*/
ALTER TABLE Aplikanti 
ADD AplikantID INT CONSTRAINT PK_Aplikanti PRIMARY KEY IDENTITY(1,1)
/*
4. U bazi ZadaciZaVjezbu kreirati tabelu Projekti koji će sadržavati sljedeće kolone: Naziv
projekta, Akronim projekta, Svrha projekta i Cilj projekta. Sva polja u tabeli su
tekstualnog tipa, te prilikom kreiranja istih paziti da se ne zauzimaju bespotrebno
memorijski resursi. Sva navedena polja osim cilja projekta moraju imati vrijednost.
*/
CREATE TABLE Projekti (
NazivProjekta NVARCHAR(15) NOT NULL,
AkronimProjekta NVARCHAR(15) NOT NULL,
SvrhaProjekta NVARCHAR(50) NOT NULL,
CiljProjekta NVARCHAR(50)
)
/*
5. U tabelu Projekti dodati kolonu Sifra projekta, te je proglasiti primarnim ključem
tabele.
*/
ALTER TABLE Projekti 
ADD SifraProjekta INT CONSTRAINT PK_Projekti PRIMARY KEY
/*
6. U tabelu Aplikanti dodati kolonu projekatID koje će biti spoljni ključ na tabelu projekat.
*/
ALTER TABLE Aplikanti
ADD projekatID INT CONSTRAINT FK_Aplikanti_Projekti FOREIGN KEY REFERENCES Projekti(SifraProjekta)
/*
7. U bazi podataka ZadaciZaVjezbu kreirati tabelu TematskeOblasti koja će sadržavati
sljedeća polja tematskaOblastID, naziv i opseg. TematskaOblastID predstavlja primarni
ključ tabele, te se automatski uvećava. Sva definisana polja moraju imati vrijednost.
Prilikom definisanja dužine polja potrebno je obratiti pažnju da se ne zauzimaju
bespotrebno memorijski resursi.
*/
CREATE TABLE TematskeOblasti (
tematskaOblastID INT NOT NULL CONSTRAINT PK_TematskeOblasti PRIMARY KEY IDENTITY(1,1),
naziv NVARCHAR(15),
opseg NVARCHAR(15)
)
/*
8. U tabeli Aplikanti dodati polje email koje je tekstualnog tipa i može ostati prazno.
*/
ALTER TABLE Aplikanti
ADD email NVARCHAR(20)
/*
9. U tabeli Aplikanti obrisati mjesto rođenja i dodati polja telefon i matični broj. Oba
novokreirana polja su tekstualnog tipa i moraju sadržavati vrijednost.
*/
ALTER TABLE Aplikanti
DROP COLUMN Mjesto_rodjenja

ALTER TABLE Aplikanti
ADD telefon NVARCHAR(15) NOT NULL,
maticniBroj NVARCHAR(20) NOT NULL
/*
10. Obrisati tabele kreirane u prethodnim zadacima
*/
DROP TABLE Aplikanti, TematskeOblasti, Projekti
/*
11. Obrisati kreiranu bazu
*/
USE master
GO
DROP DATABASE ZadaciZaVjezbu
