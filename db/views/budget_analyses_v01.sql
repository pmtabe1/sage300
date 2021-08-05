SELECT
  b.customer, b.customer_name, b.salesperson, b.category,
  b.category_description, b.comments, b.year,
  ISNULL(SUM(s.FAMTSALES - s.FRETSALES), 0) AS current_year_netsales,
  AVG((amount/12)*MONTH(GETDATE())) AS ytd_budget,
  (ISNULL(SUM(s.FAMTSALES - s.FRETSALES), 0) - AVG((amount/12)*MONTH(GETDATE()))) AS difference,
  AVG(amount) AS current_year_budget
FROM budgets b
LEFT JOIN OESHDT s ON b.customer = s.CUSTOMER COLLATE DATABASE_DEFAULT
  AND b.salesperson = s.SALESPER COLLATE DATABASE_DEFAULT
  AND b.category = s.CATEGORY COLLATE DATABASE_DEFAULT
  AND b.year = s.YR COLLATE DATABASE_DEFAULT
GROUP BY b.customer, b.customer_name, b.salesperson,
  b.category, b.category_description, b.comments,
  b.year, s.SALESPER
