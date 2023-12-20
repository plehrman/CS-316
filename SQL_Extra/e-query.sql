WITH MonthlySales AS (
    SELECT
        m.Month AS OrderMonth,
        p.ProductID,
        p.ProductName,
        COALESCE(SUM(od.Quantity), 0) AS TotalQuantity
    FROM
        (SELECT DISTINCT EXTRACT(MONTH FROM generate_series('1996-08-01'::date, '1996-10-31'::date, interval '1 month')) AS Month) m
    CROSS JOIN
        (SELECT DISTINCT ProductID, ProductName FROM products) p
    LEFT JOIN
        orders o ON m.Month = EXTRACT(MONTH FROM o.OrderDate)
    LEFT JOIN
        ordersdetails od ON o.OrderID = od.OrderID AND p.ProductID = od.ProductID
    GROUP BY
        m.Month, p.ProductID, p.ProductName
),
LagStep AS (
    SELECT
        ms.OrderMonth,
        ms.ProductID,
        ms.ProductName,
        ms.TotalQuantity,
        ms.TotalQuantity - LAG(ms.TotalQuantity, 1, 0) OVER (PARTITION BY ms.ProductID ORDER BY ms.OrderMonth) AS QuantityIncrease
    FROM
        MonthlySales ms
    ORDER BY OrderMonth
), 
RankStep AS (
    SELECT
        ls.OrderMonth,
        RANK() OVER (PARTITION BY ls.OrderMonth ORDER BY ls.QuantityIncrease DESC) AS rank,
        ls.ProductID,
        ls.ProductName,
        ls.TotalQuantity AS quantity,
        ls.QuantityIncrease AS delta
    FROM
        LagStep ls
)

SELECT * FROM RankStep WHERE rank <= 3;
