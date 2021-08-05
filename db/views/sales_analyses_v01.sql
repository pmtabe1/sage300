SELECT
  IDCUST, NAMECUST, CODESLSP1, CODESLSP2, CODESLSP3,
  IDGRP, IDNATACCT, CODETERR, NAMECITY, CODESTTE, CODECTRY,
  ITEMNO, FMTITEMNO, [DESC], items_rankings.abc_sales_rank AS RANKING,
  OPTFCAT, OPTFDEP, OPTFPROD, OPTFCOL,
  OPTFTYPE, SUBFAMILY, CATEGORY, CATDESC, SALESPER,
  TERRITORY, LOCATION, COMMODIM, YR, PERIOD,
  SUM(QTYSOLD) AS QTYSOLD,
  SUM(FAMTSALES) AS FAMTSALES,
  SUM(FCSTSALES) AS FCSTSALES,
  SUM(FRETSALES) AS FRETSALES,
  SUM(NETSALES) AS NETSALES,
  SUM(MARAMOUNT) AS MARAMOUNT,
  SUM(YTDQTYSOLD) AS YTDQTYSOLD,
  SUM(YTDFAMTSALES) AS YTDFAMTSALES,
  SUM(YTDFCSTSALES) AS YTDFCSTSALES,
  SUM(YTDFRETSALES) AS YTDFRETSALES,
  SUM(YTDNETSALES) AS YTDNETSALES,
  SUM(YTDGROSMARGIN) AS YTDGROSMARGIN,
  VENDOR1, VENDOR2, VENDOR3, VENDOR4, VENDOR5, VENDOR6
FROM sales_analysis_details
LEFT JOIN items_rankings ON ITEMNO = items_rankings.item
WHERE (YR >= YEAR(DATEADD(MONTH, - 36, GETDATE())))
GROUP BY IDCUST, NAMECUST, CODESLSP1, CODESLSP2, CODESLSP3,
  IDGRP, IDNATACCT, CODETERR, NAMECITY, CODESTTE, CODECTRY,
  ITEMNO, FMTITEMNO, [DESC], OPTFCAT, OPTFDEP, OPTFPROD,
  OPTFTYPE, OPTFCOL, SUBFAMILY, CATEGORY, CATDESC, SALESPER,
  TERRITORY, LOCATION, COMMODIM, YR, PERIOD, items_rankings.abc_sales_rank,
  VENDOR1, VENDOR2, VENDOR3, VENDOR4, VENDOR5, VENDOR6
