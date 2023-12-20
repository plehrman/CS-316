WITH ForeignSales AS (
    SELECT
        c.Country AS DomesticCountry,
        s.Country AS ForeignCountry,
        SUM(od.Quantity * p.Price) AS GrossSales
    FROM
        customers c
    LEFT JOIN
        orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN
        ordersdetails od ON o.OrderID = od.OrderID
    LEFT JOIN
        products p ON od.ProductID = p.ProductID
    LEFT JOIN
        suppliers s ON p.SuppliersID = s.SupplierID
    WHERE
        c.Country <> s.Country  
    GROUP BY
        c.Country, s.Country
    ORDER BY
        c.Country, s.Country
),

MaxSales AS (
    SELECT 
    fs.DomesticCountry AS country,
    MAX(fs.GrossSales) AS foreignmax
    FROM
        ForeignSales fs
    GROUP BY 
        fs.DomesticCountry
),

DomesticSales AS (
    SELECT
        c.Country AS DomesticCountry,
        s.Country AS ForeignCountry,
        SUM(od.Quantity * p.Price) AS GrossSales
    FROM
        customers c
    LEFT JOIN
        orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN
        ordersdetails od ON o.OrderID = od.OrderID
    LEFT JOIN
        products p ON od.ProductID = p.ProductID
    LEFT JOIN
        suppliers s ON p.SuppliersID = s.SupplierID
    WHERE
        c.Country = s.Country  
    GROUP BY
        c.Country, s.Country
    ORDER BY
        c.Country, s.Country
),

Countries AS (
    SELECT DISTINCT country
    FROM customers
),

IntStep AS (
    SELECT c.country, ms.foreignmax, ds.GrossSales as domestic
    FROM Countries c
    LEFT JOIN MaxSales ms ON c.country = ms.country
    LEFT JOIN DomesticSales ds ON ms.country = ds.DomesticCountry
)

SELECT DISTINCT country, ForeignCountry supplier_country, foreignmax, domestic
FROM IntStep
LEFT JOIN ForeignSales fs ON IntStep.foreignmax = fs.GrossSales
ORDER BY country, ForeignCountry;

