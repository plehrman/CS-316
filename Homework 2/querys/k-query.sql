
SELECT df.beer, df.mininmum price, df.bar
FROM (SELECT *
FROM (SELECT df1.name beer, MIN(df1.price) mininmum
FROM (SELECT name, bar, price FROM Beer LEFT OUTER JOIN Serves
        ON Beer.name = Serves.beer) df1
GROUP BY df1.name) data1

LEFT OUTER JOIN

(SELECT name, bar, price FROM Beer LEFT OUTER JOIN Serves
        ON Beer.name = Serves.beer) data2 ON data1.beer = data2.name AND 
                                             data1.mininmum = data2.price) df;
                                             
