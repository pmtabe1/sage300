class CreateUnpaidPayables < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists UnPaidPayable
    SQL

    execute <<-SQL
    CREATE VIEW [dbo].[UnPaidPayable] AS
    SELECT
        IDVEND AS VENDORID, VENDNAME, CODECTRY, IDINVC, IDORDERNBR, 
        CASE 
            WHEN d .[TXTTRXTYPE] = 1 THEN 'Invoice'
            WHEN d .[TXTTRXTYPE] = 2 THEN 'Debit Note'
            WHEN d .[TXTTRXTYPE] = 3 THEN 'Credit Note'
            WHEN d .[TXTTRXTYPE] = 4 THEN 'Interest'
            WHEN d .[TXTTRXTYPE] = 10 THEN 'Prepayment'
            WHEN d .[TXTTRXTYPE] = 11 THEN 'Payment'
            ELSE 'Unknown'
        END AS DOCTYPE, IDVENDGRP, DATEINVC, DATEINVCDU, DATEASOF, DATELSTACT, DATELSTSTM, CODETERM,
        CODECURN, AMTINVCHC, AMTDUEHC, ISNULL
            (
                (SELECT TOP (1) SUM(PCTDUE) AS Expr1
                FROM dbo.ARRTB AS t
                WHERE (CODETERM = d.CODETERM) AND (DATEADD(DAY, DUEDAYS, CONVERT(DATE, NULLIF (CONVERT(VARCHAR(10), CONVERT(INT, d.DATEINVC)), 0))) < GETDATE())
                GROUP BY CODETERM) * AMTINVCHC / 100, 0
            ) AS INAMTOVER, ISNULL
            (
                (SELECT TOP (1) SUM(PCTDUE) AS Expr1
                FROM dbo.ARRTB AS t
                WHERE (CODETERM = d.CODETERM) AND (DATEADD(DAY, DUEDAYS, CONVERT(DATE, NULLIF (CONVERT(VARCHAR(10), CONVERT(INT, d.DATEINVC)), 0))) < GETDATE())
                GROUP BY CODETERM), 0
            ) AS TERMPERTOVER, ISNULL
            (
                (SELECT TOP (1) DATEDIFF(DAY, DATEADD(DAY, DUEDAYS, CONVERT(DATE, NULLIF (CONVERT(VARCHAR(10), CONVERT(INT, d.DATEINVC)), 0))), GETDATE()) AS Expr1
                FROM dbo.ARRTB AS t
                WHERE (CODETERM = d.CODETERM)
                ORDER BY CODETERM, CNTPAYM), 0
            ) AS TERMDAYSOVER
    FROM dbo.APOBL AS d
    JOIN APVEN ON d.IDVEND = APVEN.VENDORID
    WHERE (SWPAID = 0)
    SQL
  end
end
