SELECT name
FROM Drinker, Frequents
WHERE Drinker.name = Frequents.drinker
AND Frequents.bar = 'James Joyce Pub';