SELECT name,address
FROM Drinker, Frequents
WHERE Drinker.name = Frequents.drinker
AND Frequents.bar = 'Down Under Pub'AND Frequents.times_a_week = 2;