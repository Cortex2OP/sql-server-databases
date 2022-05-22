--1. Prikazati tip popusta, naziv prodavnice i njen id. (Pubs)
SELECT D.discounttype, S.stor_name, S.stor_id
FROM dbo.stores AS S
INNER JOIN dbo.discounts AS D
ON D.stor_id = S.stor_id
--2. Prikazati ime uposlenika, njegov id, te naziv posla koji obavlja. (Pubs)SELECT E.fname + ' ' + E.lname AS 'Ime i prezime', E.emp_idFROM dbo.employee AS EINNER JOIN jobs AS JON J.job_id = E.job_id--3. Prikazati spojeno ime i prezime uposlenika, teritoriju i regiju koju pokriva. Uslov je da
--su zaposlenici mlađi od 60 godina. (Northwind)