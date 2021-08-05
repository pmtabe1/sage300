class CreateViewUnpaidReceivables < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists UnPaidReceivable
    SQL

    execute <<-SQL
      CREATE VIEW UnPaidReceivable AS
        SELECT  
          CASE 
              WHEN d .[TRXTYPETXT] = 1 THEN 'Invoice'
              WHEN d .[TRXTYPETXT] = 2 THEN 'Debit Note'
              WHEN d .[TRXTYPETXT] = 3 THEN 'Credit Note'
              WHEN d .[TRXTYPETXT] = 4 THEN 'Interest'
              WHEN d .[TRXTYPETXT] = 5 THEN 'Unapplied Cash'
              WHEN d .[TRXTYPETXT] = 10 THEN 'Prepayment'
              WHEN d .[TRXTYPETXT] = 11 THEN 'Receipt'
              WHEN d .[TRXTYPETXT] = 19 THEN 'Refund' 
              ELSE 'Unknown' 
          END AS DOCTYPE,
          d.IDCUST, NAMECUST, IDINVC, IDORDERNBR, d.IDGRP, DATEINVC, DATEDUE, DATEASOF,
          d.CODESLSP1, d.CODESLSP2, d.CODESLSP3, d.CODESLSP4, d.CODESLSP5 IDSHIPNBR, d.CODETERR, CODECTRY,
          DATELSTACT, DATELSTSTM, d.CODETERM, d.CODECURN, AMTINVCHC, AMTDUEHC, ISNULL
          (
              (
                  SELECT TOP(1) AMTDUEHC
                  FROM ARRTB AS t
                  WHERE DATEDIFF(DAY, (CONVERT(DATE, NULLIF (CONVERT(VARCHAR(8), CONVERT(INT, d.DATEDUE)), 0))), CONVERT(DATE, GETDATE(),0) ) > t.DUEDAYS
                  GROUP BY DUEDAYS
                  ORDER BY DUEDAYS DESC
              ), 0
          ) AS INAMTOVER, ISNULL
          (
              (
                  SELECT TOP (1) SUM(PCTDUE) AS Expr1
                  FROM dbo.ARRTB AS t
                  WHERE (CODETERM = d.CODETERM) AND (DATEADD(DAY, DUEDAYS, CONVERT(DATE, NULLIF (CONVERT(VARCHAR(10), CONVERT(INT, d.DATEINVC)), 0))) < GETDATE())
                  GROUP BY CODETERM
              ), 0
          ) AS TERMPERTOVER, ISNULL
          (
              (
                  SELECT TOP (1) 
                  CASE 
                      WHEN DATEDIFF(DAY, (CONVERT(DATE, NULLIF (CONVERT(VARCHAR(8), CONVERT(INT, d.DATEDUE)), 0))), CONVERT(DATE, GETDATE(),0)) < 0
                      THEN DATEDIFF(DAY, (CONVERT(DATE, NULLIF (CONVERT(VARCHAR(8), CONVERT(INT, d.DATEDUE)), 0))), CONVERT(DATE, GETDATE(),0)) * -1
                  ELSE
                      DATEDIFF(DAY, (CONVERT(DATE, NULLIF (CONVERT(VARCHAR(8), CONVERT(INT, d.DATEDUE)), 0))), CONVERT(DATE, GETDATE(),0))
                  END 
                  FROM dbo.ARRTB AS t
                  WHERE (CODETERM = d.CODETERM)
                  ORDER BY CODETERM, CNTPAYM
              ), 0
          ) AS TERMDAYSOVER
      
      FROM dbo.AROBL AS d
      JOIN ARCUS ON d.IDCUST = ARCUS.IDCUST
      WHERE (SWPAID = 0)
    SQL
  end
end
