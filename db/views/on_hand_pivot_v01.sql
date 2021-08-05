SELECT
  ITEMNO, [1] AS Loc1, [1L] AS Loc1L, [10L] AS Loc10L, [10] AS Loc10, [5L] AS Loc5L, 
  [4D] AS Loc4D, [2D] AS Loc2D, [2M] AS Loc2M, [10M] AS Loc10M, [9] AS Loc9, [12] AS Loc12
FROM 
  (
      SELECT ITEMNO, LOCATION, QTYONHAND
      FROM  dbo.ICILOC
      WHERE LOCATION IN ('1', '1L', '10L', '10', '5L', '4D', '2D', '2M', '10M', '9', '12')
  ) d PIVOT (SUM(QTYONHAND) FOR LOCATION IN ([1], [1L], [10L], [10], [5L], [4D], [2D], [2M], [10M], [9], [12])) AS on_hand
