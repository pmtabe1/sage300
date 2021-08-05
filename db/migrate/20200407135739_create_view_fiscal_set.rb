class CreateViewFiscalSet < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists FiscalSet
    SQL

    execute <<-SQL
      CREATE VIEW FiscalSet AS
      SELECT ACCTID, FSCSYR,
      AMOUNT, CURNTYPE, FSCSDSG,
      CASE FSPERD
        WHEN 'NETPERD1' THEN '01'
        WHEN 'NETPERD2' THEN '02'
        WHEN 'NETPERD3' THEN '03'
        WHEN 'NETPERD4' THEN '04'
        WHEN 'NETPERD5' THEN '05'
        WHEN 'NETPERD6' THEN '06'
        WHEN 'NETPERD7' THEN '07'
        WHEN 'NETPERD8' THEN '08'
        WHEN 'NETPERD9' THEN '09'
        WHEN 'NETPERD10' THEN '10'
        WHEN 'NETPERD11' THEN '11'
        WHEN 'NETPERD12' THEN '12'
      END AS FSPERD
      FROM GLAFS
      UNPIVOT (
        AMOUNT
        FOR FSPERD IN (
          NETPERD1,NETPERD2,NETPERD3,NETPERD4,
          NETPERD5,NETPERD6,NETPERD7,NETPERD8,
          NETPERD9,NETPERD10,NETPERD11,NETPERD12
        )  
      ) AS FSPERD
    SQL
  end
end
