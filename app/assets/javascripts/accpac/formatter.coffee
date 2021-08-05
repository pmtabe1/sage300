@dateFormatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      date = params.value.toString()
      String date.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3')

# Formating Number Functions

@currencyFormatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      '$' + Math.floor(params.value).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')

# Currency multiple decimal decimals
@currency6Formatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      '$' + Number((params.value * 1).toFixed(6))

@currency4Formatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      '$' + Number((params.value * 1).toFixed(4))

@currency2Formatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      '$' + Number((params.value * 1).toFixed(2))

@quantity4Formatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      Number((params.value * 1).toFixed(4))

@quantityFormatter = (params) ->
  if params.value == null or params.value == undefined
    null
  else if isNaN(params.value)
    'NaN'
  else
    # if we are doing 'count', then we do not show pound sign
    if params.node.group and params.column.aggFunc == 'count'
      params.value
    else
      parseFloat(Math.round(params.value * 100) / 100).toFixed(2).toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'
      #Math.round(params.value).toFixed(2).toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'
