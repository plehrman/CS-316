SELECT drinker
FROM (SELECT drinker, COUNT(drinker) as num
FROM Likes
GROUP BY drinker) as df
WHERE num > 4;
