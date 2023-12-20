(SELECT DISTINCT Frequents.drinker
FROM Frequents, Serves
WHERE Frequents.bar = Serves.bar
AND Serves.beer = 'Budweiser')

INTERSECT

((SELECT DISTINCT drinker
FROM Likes)

EXCEPT

(SELECT DISTINCT drinker
FROM Likes
WHERE beer = 'Budweiser'));






