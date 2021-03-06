class CreateViewItemsRankingLocation < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists ItemsRankingLocation
    SQL

    execute <<-SQL
    CREATE VIEW ItemsRankingLocation AS
      SELECT
      q.LOCATION AS location, q.ITEM AS item,
      CASE
        WHEN SUM(q.SALES_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.SALES_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.SALES_AMOUNT) OVER (PARTITION BY q.LOCATION),0) <= 0.7 THEN 'A'
        WHEN SUM(q.SALES_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.SALES_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.SALES_AMOUNT) OVER (PARTITION BY q.LOCATION),0) <= 0.9 THEN 'B'
        ELSE 'C'
      END AS abc_sales_rank,
      DENSE_RANK() OVER (PARTITION BY q.LOCATION ORDER BY q.SALES_AMOUNT DESC) AS dense_sales_rank,
      CASE
        WHEN SUM(q.COST_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.COST_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.COST_AMOUNT) OVER (PARTITION BY q.LOCATION),0) <= 0.7 THEN 'A'
        WHEN SUM(q.COST_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.COST_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.COST_AMOUNT) OVER (PARTITION BY q.LOCATION ),0) <= 0.9 THEN 'B'
        ELSE 'C'
      END AS abc_cost_rank,
      DENSE_RANK() OVER (PARTITION BY q.LOCATION ORDER BY q.COST_AMOUNT DESC) AS dense_cost_rank,
      CASE
        WHEN SUM(q.MARGIN_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.MARGIN_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.MARGIN_AMOUNT) OVER (PARTITION BY q.LOCATION),0) <= 0.7 THEN 'A'
        WHEN SUM(q.MARGIN_AMOUNT) OVER (PARTITION BY q.LOCATION ORDER BY q.MARGIN_AMOUNT DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / NULLIF(SUM(q.MARGIN_AMOUNT) OVER (PARTITION BY q.LOCATION),0) <= 0.9 THEN 'B'
        ELSE 'C'
      END AS abc_margin_rank,
      DENSE_RANK() OVER (PARTITION BY q.LOCATION ORDER BY q.MARGIN_AMOUNT DESC) AS dense_margin_rank
      FROM
      (SELECT
        RTRIM(shd.[ITEM]) AS ITEM, shd.[LOCATION] AS LOCATION, SUM(shd.[FAMTSALES]) AS SALES_AMOUNT,
        SUM(shd.[FCSTSALES]) AS COST_AMOUNT ,SUM(shd.[FAMTSALES]) - SUM(shd.[FCSTSALES]) AS MARGIN_AMOUNT
        FROM [OESHDT] shd
        WHERE DATEADD(MONTH, -36, GETDATE()) <= CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,shd.[TRANDATE])),0))
        GROUP BY shd.[ITEM], shd.[LOCATION])q
    SQL
  end
end
