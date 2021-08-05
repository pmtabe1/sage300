SELECT
    POPORH1.PORHSEQ, POPORL.PORLREV, POPORL.PORLSEQ, POPORH1.PONUMBER,
    POPORH1.VDCODE, POPORH1.VDNAME, POPORL.ITEMNO,
    POPORL.LOCATION, POPORH1.DATE, POPORL.OQORDERED, POPORL.OQRECEIVED,
    POPORL.OQOUTSTAND, proforma_invoice.quantity AS PRODUCTION, proforma_invoice.etd AS ETD,
    paking_list.quantity AS PACKED, paking_list.name AS DOCTYPE, paking_list.created_at AS PACKDATE,
    bl.eta AS ETA, bl.onboard AS ONBOARD, bl.container AS CONTAINER, POPORH2.ENTEREDBY,
    POPORL.UNITCOST, POPORL.EXTENDED
FROM POPORL
JOIN POPORH1 ON POPORL.PORHSEQ = POPORH1.PORHSEQ
LEFT JOIN (
    SELECT 
        porhseq, itemno, quantity, documents.id, document_types.name,
        document_lines.created_at
        FROM [ACCLTD].[dbo].[document_lines]
        JOIN documents ON document_lines.document_id = documents.id
        JOIN document_types ON documents.document_type_id = document_types.id
        WHERE document_types.slug = 'packing-list'
)paking_list ON POPORL.PORHSEQ = paking_list.porhseq AND POPORL.ITEMNO = paking_list.itemno COLLATE DATABASE_DEFAULT
LEFT JOIN (
    SELECT 
        porhseq, itemno, quantity, documents.id, document_types.name,
        JSON_VALUE(properties_column, '$."Estimated Time of Delivery (ETD)"') AS etd, document_lines.created_at
        FROM [ACCLTD].[dbo].[document_lines]
        JOIN documents ON document_lines.document_id = documents.id
        JOIN document_types ON documents.document_type_id = document_types.id
        WHERE document_types.slug = 'proforma-invoice'
)proforma_invoice ON POPORL.PORHSEQ = proforma_invoice.porhseq AND POPORL.ITEMNO = proforma_invoice.itemno COLLATE DATABASE_DEFAULT
LEFT JOIN (
    SELECT 
        porhseq, itemno, quantity, documents.id, document_types.name,
        JSON_VALUE(properties_column, '$."On Board Date"') AS onboard,
        JSON_VALUE(properties_column, '$."Estimated Time of Arrival (ETA)"') AS eta,
        JSON_VALUE(properties_column, '$."Container Number"') AS container, 
        document_lines.created_at
        FROM [ACCLTD].[dbo].[document_lines]
        JOIN documents ON document_lines.document_id = documents.id
        JOIN document_types ON documents.document_type_id = document_types.id
        WHERE document_types.slug = 'bill-of-lading'
)bl ON POPORL.PORHSEQ = bl.porhseq AND POPORL.ITEMNO = bl.itemno COLLATE DATABASE_DEFAULT
JOIN POPORH2 ON POPORH1.PORHSEQ = POPORH2.PORHSEQ
WHERE POPORL.COMPLETION = 1
