SELECT df1.bar, drinker
FROM (SELECT bar, MAX(times_a_week) as num
FROM Frequents
GROUP BY bar) df1, (SELECT F.drinker, S.bar, F.times_a_week
FROM (SELECT bar
FROM Serves
WHERE beer = 'Corona') S, Frequents F
WHERE S.bar = F.bar) df2
WHERE df1.bar = df2.bar
AND num = times_a_week;







