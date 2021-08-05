class CreateViewUsersReport < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists MontlyUsersReport
    SQL

    execute <<-SQL
    CREATE VIEW MonthlyUsersReport AS

      SELECT
        COUNT(ORDNUMBER) AS ORDERS, h1.ENTEREDBY,
        CONVERT(DATE, CAST(h.ORDDATE AS VARCHAR(8)), 112) AS ORDDATE, 
        YEAR(CONVERT(DATE, CAST(h.ORDDATE AS VARCHAR(8)), 112)) AS YEAR,
        MONTH(CONVERT(DATE, CAST(h.ORDDATE AS VARCHAR(8)), 112)) AS MONTH
      FROM OEORDH h
      JOIN OEORDH1 h1 ON h.ORDUNIQ = h1.ORDUNIQ
      GROUP BY h.ORDDATE, h1.ENTEREDBY
    SQL
  end
end
