SELECT
  iof.ITEMNO, iof.FMTITEMNO, iof.[DESC],
  iof.CATEGORY, iof.CATDESC,
  ma.LOCATION, abc_sales_rank AS SALESRANK, dense_sales_rank AS DENSESALESRANK,
  ICILOC.QTYONHAND, ICILOC.QTYSALORDR, ICILOC.QTYONORDER, ICILOC.QTYCOMMIT,
  ma.TOWYEARSQTY, ma.FOURQUARTERQTY,
  ma.THIRDQUARTERQTY, ma.SECONDQUARTERQTY,
  ma.FIRSTQUARTERQTY
FROM item_moving_averages ma
JOIN item_optional_fields iof ON ma.ITEMNO = iof.ITEMNO COLLATE DATABASE_DEFAULT
JOIN ICILOC ON ma.ITEMNO = ICILOC.ITEMNO AND ma.LOCATION = ICILOC.[LOCATION] COLLATE DATABASE_DEFAULT
LEFT JOIN item_ranks ON item = ma.ITEMNO COLLATE DATABASE_DEFAULT
