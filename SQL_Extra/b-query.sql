WITH order_categories AS (
    SELECT DISTINCT orderid, c.categoryid, c.categoryname
    FROM categories c
    JOIN products p ON c.categoryid = p.categoryid
    JOIN ordersdetails od ON p.productid = od.productid
    )

SELECT c.categoryname, COUNT(oc.categoryname)
FROM categories c
LEFT JOIN order_categories oc ON c.categoryid = oc.categoryid
GROUP BY c.categoryname
ORDER BY count DESC;

