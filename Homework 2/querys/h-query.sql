(SELECT bar, drinker
FROM Frequents)
EXCEPT
(SELECT DISTINCT F.bar, F.drinker
FROM Frequents F, Serves S, Likes L
WHERE F.bar = S.bar
AND F.drinker = L.drinker
AND L.beer = S.beer);