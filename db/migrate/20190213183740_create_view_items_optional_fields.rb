class CreateViewItemsOptionalFields < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists ItemOptionalFields
    SQL

    execute <<-SQL
      CREATE VIEW ItemOptionalFields AS
      SELECT
        i.ITEMNO, i.FMTITEMNO, i.[DESC],
        (SELECT VALUE FROM dbo.ICITEMO AS o WHERE (i.ITEMNO = ITEMNO) AND (OPTFIELD = 'CATEGORY')) AS OPTFCAT,
        (SELECT VALUE FROM dbo.ICITEMO AS o WHERE (i.ITEMNO = ITEMNO) AND (OPTFIELD = 'DEPT')) AS OPTFDEPT,
        (SELECT VALUE FROM dbo.ICITEMO AS o WHERE (i.ITEMNO = ITEMNO) AND (OPTFIELD = 'PRODUCT')) AS OPTFPROD,
        (SELECT VALUE FROM dbo.ICITEMO AS o WHERE (i.ITEMNO = ITEMNO) AND (OPTFIELD = 'TYPE')) AS OPTFTYPE, 
        i.CATEGORY, c.[DESC] AS CATDESC, 
        CASE i.[INACTIVE] 
          WHEN 0 THEN 'Active' 
          WHEN 1 THEN 'Inactive' 
          ELSE 'Unknown' 
        END AS STATUS
      FROM
        dbo.ICITEM AS i
      INNER JOIN dbo.ICCATG AS c ON i.AUDTORG = c.AUDTORG AND i.CATEGORY = c.CATEGORY
    SQL
  end
end
