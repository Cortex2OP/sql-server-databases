--1.	Kreirati bazu podataka pod nazivom ZadaciZaVjezbu. 
CREATE DATABASE ZadaciZaVjezbu
GO 
USE ZadaciZaVjezbu

--2.	U pomenutoj bazi kreirati tabelu Aplikanti koja æe sadržavati sljedeæe kolone: Ime, Prezime i Mjesto_roðenja. Sva navedena polja trebaju da budu tekstualnog tipa, te prilikom kreiranja istih paziti da se ne zauzimaju bespotrebno memorijski resursi.
CREATE TABLE Aplikanti
(
Ime NVARCHAR(10),
Prezime NVARCHAR(20),
MjestoRodjenja NVARCHAR(50)
)
--3.	U tabelu Aplikanti dodati kolonu AplikantID, te je proglasiti primarnim kljuèem tabele (kolona mora biti autonkrement)
ALTER TABLE Aplikanti
ADD AplikantID INT NOT NULL IDENTITY(1,1)

ALTER TABLE Aplikanti
ADD CONSTRAINT PK_Aplikant PRIMARY KEY(AplikantID)
--4.	U bazi ZadaciZaVjezbu kreirati tabelu Projekti koji æe sadržavati sljedeæe kolone: Naziv projekta, Akronim projekta, Svrha projekta i Cilj projekta. Sva polja u tabeli su tekstualnog tipa, te prilikom kreiranja istih paziti da se ne zauzimaju bespotrebno memorijski resursi. Sva navedena polja osim cilja projekta moraju imati vrijednost.
CREATE TABLE Projekti
(
NazivProjekta NVARCHAR(30) NOT NULL,
AkronimProjekta NVARCHAR(30) NOT NULL,
SvrhaProjekta NVARCHAR(150) NOT NULL,
CiljProjekta NVARCHAR(150)

)
--5.	U tabelu Projekti dodati kolonu Sifra projekta, te je proglasiti primarnim kljuèem tabele. 
ALTER TABLE Projekti
ADD SifraProjekta NVARCHAR(30) PRIMARY KEY 
--6.	U tabelu Aplikanti dodati kolonu projekatID koje æe biti spoljni kljuè na tabelu projekat.
ALTER TABLE Aplikanti
ADD ProjekatID NVARCHAR(30) NOT NULL CONSTRAINT FK_Aplikant_Projekti FOREIGN KEY REFERENCES Projekti(sifraProjekta)
--7.	U bazi podataka ZadaciZaVjezbu kreirati tabelu TematskeOblasti koja æe sadržavati sljedeæa polja tematskaOblastID, naziv i opseg. TematskaOblastID predstavlja primarni kljuè tabele, te se automatski uveæava. Sva definisana polja moraju imati vrijednost. Prilikom definisanja dužine polja potrebno je obratiti pažnju da se ne zauzimaju bespotrebno memorijski resursi.
CREATE TABLE TematskeOblasti
(
TematskaOblastID INT CONSTRAINT PK_TematskaOblast PRIMARY KEY,
Naziv NVARCHAR(50) NOT NULL,
Opseg NVARCHAR(150) NOT NULL
)
--8.	U tabeli Aplikanti dodati polje email koje je tekstualnog tipa i može ostati prazno.
ALTER TABLE Aplikanti
ADD Email NVARCHAR(50)
--9.	U tabeli Aplikanti obrisati mjesto roðenja i dodati polja telefon i matièni broj. Oba novokreirana polja su tekstualnog tipa i moraju sadržavati vrijednost.
ALTER TABLE Aplikanti
DROP COLUMN MjestoRodjenja

ALTER TABLE Aplikanti 
ADD Telefon NVARCHAR(10) NOT NULL,
MaticniBroj NVARCHAR(13) NOT NULL --CONSTRAINT UQ_Aplikanti_MaticniBroj UNIQUE
--10.	Obrisati tabele kreirane u prethodnim zadacima 
DROP TABLE Aplikanti, TematskeOblasti, Projekti
--11.	Obrisati kreiranu bazu
DROP DATABASE ZadaciZaVjezbu
