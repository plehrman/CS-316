SELECT df.bar1, df.bar2
FROM (SELECT *
FROM (SELECT bar bar1, COUNT(beer) count1
FROM Serves
GROUP BY bar) S1, (SELECT bar bar2, COUNT(beer) count2
FROM Serves
GROUP BY bar) S2
WHERE S1.bar1 <> S2.bar2
AND S1.count1 < S2.count2) df

WHERE NOT EXISTS

((SELECT beer FROM Serves
WHERE df.bar1 = Serves.bar)
EXCEPT
(SELECT beer FROM Serves
WHERE df.bar2 = Serves.bar));

