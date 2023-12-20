SELECT name, address 
FROM (SELECT DISTINCT l1.drinker
FROM Likes l1, Likes l2, Drinker
WHERE l1.drinker = l2.drinker
AND l1.beer = 'Corona'
And l2.beer = 'Dixie') as df, Drinker
WHERE df.Drinker = Drinker.name;
