--Esercitazione1
--Scrivere il codice PostgreSQL che generi tutte le tabelle. Per gli attributi di cui non è stato speciﬁcato il tipo, scegliere quello opportuno. 
--Speciﬁcare tutti i vincoli possibili, sia intra- sia inter-relazionali. 

DROP DOMAIN IF EXISTS GIORNI_SETTIMANA CASCADE; --elimio il dominio altrimenti non posso rieseguire
												 --CASCADE elimina tutte le righe delle atre tabelle che hanno come dominio GIORNI_SETTIMANA
CREATE DOMAIN GIORNI_SETTIMANA AS CHAR(3)
	CHECK(VALUE IN ('LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM'))
	NOT NULL;

DROP TABLE IF EXISTS museo CASCADE;
CREATE TABLE Museo(
	nome VARCHAR(30) DEFAULT 'Museo Veronese',
	città VARCHAR(20) DEFAULT 'Verona',
	indirizzo VARCHAR(160) NOT NULL,
	numeroTelefono VARCHAR(16) NOT NULL,
	giornoChiusura GIORNI_SETTIMANA,
	prezzo NUMERIC(6, 2) NOT NULL CHECK(prezzo >= 0.00) DEFAULT 10.00,		--assumo prezzi in euro
	
	PRIMARY KEY(nome, città)
);

DROP TABLE IF EXISTS Mostra;
CREATE TABLE Mostra(
	titolo VARCHAR(30),
	inizio DATE,
	fine DATE NOT NULL,
	nomeMuseo VARCHAR(30) NOT NULL,
	cittàMuseo VARCHAR(20) NOT NULL, 
	città VARCHAR(20) NOT NULL,
	prezzo NUMERIC(6, 2) NOT NULL CHECK(prezzo >= 0.00),
	
	PRIMARY KEY(titolo, inizio),
	FOREIGN KEY (nomeMuseo, cittàMuseo) REFERENCES Museo(nome, città) 
);

DROP TABLE IF EXISTS Opera;
CREATE TABLE  Opera(
	nome VARCHAR(30),
	cognomeAutore VARCHAR(20),
	nomeAutore VARCHAR(20),
	nomeMuseo VARCHAR(30) NOT NULL,
	cittàMuseo VARCHAR(20) NOT NULL,
	città VARCHAR(20) NOT NULL,
	epoca VARCHAR(10) NOT NULL,
	anno VARCHAR(4) NOT NULL,
	
	PRIMARY KEY(nome, cognomeAutore, nomeAutore),
	FOREIGN KEY(nomeMuseo, cittàMuseo) REFERENCES Museo(nome, città)
);

DROP TABLE IF EXISTS Orario;
CREATE TABLE Orario(
	progressivo Integer PRIMARY KEY,
	nomeMuseo VARCHAR(30) NOT NULL,
	cittàMuseo VARCHAR(20) NOT NULL,
	città VARCHAR(20) NOT NULL,
	giorno GIORNI_SETTIMANA,
	orarioApertura TIME WITH TIME ZONE NOT NULL DEFAULT '9:00 CET',
	orarioChiusura TIME WITH TIME ZONE NOT NULL DEFAULT '19:00 CET',
	
	FOREIGN KEY (nomeMuseo, cittàMuseo) REFERENCES Museo(nome, città)
);

--Inserire nell’entità Museo le seguenti tuple: 
--(Arena, Verona, piazza Bra, 045 8003204, martedì, 20), 
--(CastelVecchio, Verona, Corso Castelvecchio, 045 594734, lunedì, 15).

INSERT INTO Museo(nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo)
	VALUES ('Arena', 'Verona', 'piazza Bra', '045 8003204', 'MAR', 20),
			('CastelVecchio', 'Verona', 'Corso Castelvecchio', '045 594734', 'LUN', 15);
			
--Popolare le tabelle Opera e Mostra con almeno altre tre tuple ciascuna.
INSERT INTO Opera(nome, cognomeAutore, nomeAutore, nomeMuseo, cittàMuseo, città, epoca, anno)
	VALUES ('Pillars', 'Aloth', 'A', 'Arena', 'Verona', 'Verona', '18secolo', 2020),
			('Pillars2', 'Eder', 'E', 'CastelVecchio', 'Verona','Verona', '20secolo', 2019),	
			('Pillars3', 'Durance', 'D', 'Arena', 'Verona', 'Verona', '21secolo', 2020);

INSERT INTO Mostra(titolo, inizio, fine, nomeMuseo, cittàMuseo, città, prezzo)
	VALUES ('Obsidian', '2020-03-15', '2020-05-30', 'Arena', 'Verona', 'Verona', 50.00),
			('Warcraft', '2019-09-10', '2020-09-11', 'CastelVecchio', 'Verona', 'Verona', 10.00);
			
INSERT INTO Orario(progressivo, nomeMuseo, cittàMuseo, città, giorno, orarioApertura, orarioChiusura)
	VALUES ('00001', 'Arena', 'Verona', 'Verona', 'LUN', '10:00', '18:00'),
			('00002', 'Arena', 'Verona', 'Verona', 'MER', '08:00', '23:00'),
			('00003', 'Arena', 'Verona', 'Verona', 'VEN', '12:00', '14:00');
			
--Provare ad inserire nella relazione Museo tuple che violino i vincoli speciﬁcati.
--INSERT INTO Museo(nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo)
	--VALUES ('Azur', 'Verona', 'llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll', 
			--NULL, 'LOL', 0.00);

--Nell’entità Museo, aggiungere l’attributo sitoInternet e inserire gli opportuni valori. 
ALTER TABLE Museo ADD COLUMN sitoInternet VARCHAR(30);

UPDATE Museo
	SET sitoInternet = NULL
		WHERE nome = 'Arena' AND città = 'Verona';
		
UPDATE Museo
	SET sitoInternet = 'https:\\www.sito.it'
		WHERE nome = 'CastelVecchio' AND città = 'Verona';

--Nell’entità Mostra modiﬁcare l’attributo prezzo in prezzoIntero ed aggiungere l’attributo prezzoRidotto con valore di default 5. 
--Aggiungere il vincolo (di tabella o di attributo?) che garantisca che Mostra.prezzoRidotto sia minore di Mostra.prezzoIntero.
ALTER TABLE Mostra RENAME COLUMN prezzo TO prezzoIntero;

ALTER TABLE Mostra ADD COLUMN prezzoRidotto NUMERIC(6, 2) DEFAULT 5.00;

ALTER TABLE Mostra ADD CHECK(prezzoRidotto < prezzoIntero);

--Nell’entità Museo aggiornare il prezzo aggiungendo 1 Euro alle tuple esistenti. 
UPDATE Museo
	SET prezzo = prezzo + 1;
	
--Nell’entità Mostra aggiornare il prezzoRidotto aumentandolo di 1 Euro per quelle mostre che hanno prezzoIntero inferiore a 15 Euro.
UPDATE Mostra
	SET prezzoRidotto = prezzoRidotto + 1
		WHERE prezzoIntero < 15.00;
