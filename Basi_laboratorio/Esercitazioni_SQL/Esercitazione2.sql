--Visualizzare tutti i musei della città di Verona con il loro giorno di chiusura. 
SELECT nome, città, giornoChiusura
FROM Museo
WHERE città = 'Verona'; --WHERE LOWER(città) = 'verona' -> risolvo i problemi se verona è scritto "male"

--Visualizzare per ogni mostra che inizia con la lettera ’R’, una stringa composta dal titolo e dalla città in cui si svolge. 
SELECT titolo || città
FROM Mostra
WHERE titolo LIKE 'R%';

--Visualizzare il titolo di ogni mostra ancora in corso e quanti giorni rimane ancora aperta a partire dalla data corrente. 
--Usare la costante CURRENT_DATE per avere la data corrente. 
SELECT titolo, inizio, fine, FINE - CURRENT_DATE AS Giorni
FROM mostra
WHERE fine > CURRENT_DATE AND  inizio <= CURRENT_DATE;

--Visualizzare per ogni museo l’orario di apertura e chiusura il lunedì. 
--Se per un museo il martedì è giorno di chiusura, non mostrare nulla. 
SELECT nomeMuseo, cittàMuseo, Orario.orarioApertura, Orario.orarioChiusura
FROM Orario
WHERE giorno = 'LUN';

--Assicurarsi che almeno una mostra abbia il prezzo ridotto non valorizzato (NULL) usando eventualmente il comando UPDATE per modiﬁcare almeno una riga.
--Visualizzare tutte le mostre che hanno prezzo ridotto non valorizzato usando prima l’espressione ERRATA ’prezzoRidotto = NULL’ e poi l’espressione corretta prezzoRidotto IS NULL. 
UPDATE Mostra
	SET prezzoRidotto = NULL
		WHERE titolo = 'Warcraft';

SELECT titolo, inizio, prezzoRidotto
FROM Mostra
WHERE prezzoRidotto IS NULL;

--Visualizzare tutte le mostre non terminate in ordine di data inizio e, in caso di pari data inizio, data ﬁne. 
SELECT titolo, inizio
FROM Mostra
WHERE fine > CURRENT_DATE
ORDER BY inizio, fine;

--Visualizzare il numero totale di giorni di apertura del museo ’Arena’ di ’Verona’.
SELECT COUNT(giorno)
FROM Orario
WHERE nomeMuseo = 'Arena' AND cittàMuseo = 'Verona';

--Visualizzare le ore medie di apertura del museo ’Arena’ di ’Verona’. 
--Suggerimento: convertire orarioapertura e orariochiusure usando ’::time’. 
SELECT AVG(orarioChiusura::time - orarioApertura::time)
FROM orario
WHERE nomeMuseo = 'Arena' AND cittàMuseo = 'Verona';
--Non è possibile eseguire la differena tra due TIME WITH TIME ZONE

--Indicare il numero di autori distinti presenti in tutti i musei. 

--Visualizzare le mostre con il prezzo massimo indicando il titolo della mostra e il prezzo. 
--Suggerimento: fare il prodotto cartesiano e selezionare solo le righe con prezzo...


















--pgAdmin esegue tutte le query ma mosta solo il risultato dell'ultima