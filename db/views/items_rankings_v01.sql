SELECT
  q.ITEM AS item,
  CASE
    WHEN SUM(SALES_AMOUNT) OVER (ORDER BY SALES_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(SALES_AMOUNT) OVER (),0) <= 0.7 THEN 'A'
    WHEN SUM(SALES_AMOUNT) OVER (ORDER BY SALES_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(SALES_AMOUNT) OVER (),0) <= 0.9 THEN 'B'
    ELSE 'C'
  END AS abc_sales_rank,
  DENSE_RANK() OVER (PARTITION BY 1,2 ORDER BY SALES_AMOUNT DESC) AS dense_sales_rank,
  CASE
    WHEN SUM(COST_AMOUNT) OVER (ORDER BY COST_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(COST_AMOUNT) OVER (),0) <= 0.7 THEN 'A'
    WHEN SUM(COST_AMOUNT) OVER (ORDER BY COST_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(COST_AMOUNT) OVER (),0) <= 0.9 THEN 'B'
    ELSE 'C'
  END AS abc_cost_rank,
  DENSE_RANK() OVER (PARTITION BY 1,2 ORDER BY COST_AMOUNT DESC) AS dense_cost_rank,
  CASE
    WHEN SUM(MARGIN_AMOUNT) OVER (ORDER BY MARGIN_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(MARGIN_AMOUNT) OVER (),0) <= 0.7 THEN 'A'
    WHEN SUM(MARGIN_AMOUNT) OVER (ORDER BY MARGIN_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(MARGIN_AMOUNT) OVER (),0) <= 0.9 THEN 'B'
    ELSE 'C'
  END AS abc_margin_rank,
  DENSE_RANK() OVER (PARTITION BY 1,2 ORDER BY MARGIN_AMOUNT DESC) AS dense_margin_rank
FROM
(
  SELECT
    RTRIM(ITEM) AS ITEM,
    SUM(FAMTSALES) AS SALES_AMOUNT,
    SUM(FCSTSALES) AS COST_AMOUNT,
    SUM(FAMTSALES) - SUM(FCSTSALES) AS MARGIN_AMOUNT
  FROM OESHDT
  WHERE DATEADD(MONTH, -36, GETDATE()) <= CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,TRANDATE)),0))
  GROUP BY AUDTORG, ITEM
)q
