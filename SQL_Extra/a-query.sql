WITH SelectedProduct AS (
    SELECT DISTINCT ProductID
    FROM products
    WHERE ProductName = 'Singaporean Hokkien Fried Mee'
)

SELECT DISTINCT c.CustomerName
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN ordersdetails od ON o.OrderID = od.OrderID
JOIN SelectedProduct sp ON sp.ProductID = od.ProductID;
