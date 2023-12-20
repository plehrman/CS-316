SELECT
    EXTRACT(MONTH FROM date '1996-01-01' + interval '1 month' * m)::int4 AS month,
    COUNT(e.EmployeeID)::int8 AS employees_without_orders
FROM
    generate_series(0, 11) m  -- generates series of months from 0 to 11
LEFT JOIN
    employees e ON true
LEFT JOIN
    orders o ON e.EmployeeID = o.EmployeeID AND EXTRACT(YEAR FROM o.OrderDate) = 1996 AND EXTRACT(MONTH FROM o.OrderDate) = m + 1
WHERE
    o.OrderID IS NULL
GROUP BY
    month
ORDER BY
    month;
