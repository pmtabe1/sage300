module DashboardHelper

  ####################################
  # YTD (year to date) sales methods #
  ####################################

  # YTD current year
  def ytd_sales_current_year
    Accpac::Oeshdt.where("PERIOD <= ? AND YR = ?", Time.now.month, current_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD last year
  def ytd_sales_last_year
    Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", year_to_date_last_year, last_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD percentage up/down
  def ytd_sales_percentage
    percentage = (ytd_sales_current_year / ytd_sales_last_year)*100
    if percentage-100 > 0
      "<div class='stat-percent font-bold text-info'>
        <small>#{number_to_currency(ytd_sales_diff, precision: 0)}</small>
        #{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        <small>#{number_to_currency(ytd_sales_diff, precision: 0)}</small>
        #{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def ytd_sales_sparkline
    (1..Time.now.month).map do |month|
      number_with_precision(Accpac::Oeshdt.where("PERIOD = ? AND YR = ?", month, current_year).sum('FAMTSALES - FRETSALES'), precision: 0).to_i
    end
  end

  def ytd_sales_diff
    ytd_sales_current_year - ytd_sales_last_year
  end

  def ytd_sales_percentage_diff
    percentage = (ytd_sales_current_year/ytd_sales_last_year)*100
    if percentage-100 > 0
      "#{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up'></i>".html_safe
    else
      "#{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down'></i>".html_safe
    end
  end

  #####################################
  # YTD (year to date) margin methods #
  #####################################

  # YTD margin current year
  def ytd_margin_current_year
    Accpac::Oeshdt.where("PERIOD <= ? AND YR = ?", Time.now.month, current_year).sum('FAMTSALES - FRETSALES - FCSTSALES')
  end

  # YTD margin last year
  def ytd_margin_last_year
    Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", year_to_date_last_year, last_year).sum('FAMTSALES - FRETSALES - FCSTSALES')
  end

  # YTD margin percentage up/down
  def ytd_margin_percentage
    percentage = (ytd_margin_current_year / ytd_margin_last_year)*100
    if percentage-100 > 0
      "<div class='stat-percent font-bold text-info'>
        <small>#{number_to_currency(ytd_margin_diff, precision: 0)}</small>
        #{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        <small>(#{number_to_currency(ytd_margin_diff, precision: 0)})</small>
        #{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def ytd_margin_diff
    ytd_margin_current_year - ytd_margin_last_year
  end

  ####################################
  # YTD (year to date) month methods #
  ####################################

  # YTD month current year
  def ytd_month_current_year
    Accpac::Oeshdt.where("PERIOD = ? AND YR = ?", Time.now.month, current_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD month last year
  def ytd_month_last_year
    Accpac::Oeshdt.where("TRANDATE <= ? AND PERIOD = ? AND YR = ?", year_to_date_last_year, Time.now.month, last_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD margin percentage up/down
  def ytd_month_percentage
    percentage = (ytd_month_current_year / ytd_month_last_year)*100
    if percentage-100 > 0
      "<div class='stat-percent font-bold text-info'>
        <small>#{number_to_currency(ytd_month_diff, precision: 0)}</small>
        #{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        <small>(#{number_to_currency(ytd_month_diff, precision: 0)})</small>
        #{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def ytd_month_diff
    ytd_month_current_year - ytd_month_last_year
  end

  #############
  # Net Sales #
  #############

  # Net sales current year
  def net_sales_current_year
    Accpac::Oeshdt.where("YR = ?", current_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD month last year
  def net_sales_last_year
    Accpac::Oeshdt.where("YR = ?", last_year).sum('FAMTSALES - FRETSALES')
  end

  # YTD margin percentage up/down
  def net_sales_percentage
    percentage = (net_sales_current_year / net_sales_last_year)*100
    if percentage-100 > 0
      "<div class='stat-percent font-bold text-info'>
        <small>#{number_to_currency(net_sales_diff, precision: 0)}</small>
        #{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        <small>(#{number_to_currency(net_sales_diff, precision: 0)})</small>
        #{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def net_sales_diff
    net_sales_current_year - net_sales_last_year
  end

  def backorder_current_amount
    Views::Fulfillment.sum(:AMOUNT)
  end

  ####################
  # YTD Gross Profit #
  ####################
  def ytd_cost_of_sales_last_year
    Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", year_to_date_last_year, last_year).sum('FCSTSALES')
  end

  def ytd_cost_of_sales_current_year
    Accpac::Oeshdt.where("PERIOD <= ? AND YR = ?", Time.now.month, current_year).sum('FCSTSALES')
  end

  def ytd_returns_last_year
    Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", year_to_date_last_year, last_year).sum('FRETSALES')
  end

  def ytd_returns_current_year
    Accpac::Oeshdt.where("PERIOD <= ? AND YR = ?", Time.now.month, current_year).sum('FRETSALES')
  end

  # GP = (Revenue - Cost of Sales) / Revenue
  def ytd_gross_profit_last_year
    ((ytd_sales_last_year - ytd_cost_of_sales_last_year) / ytd_sales_last_year) * 100
  end

  def ytd_gross_profit_current_year
    ((ytd_sales_current_year - ytd_cost_of_sales_current_year) / ytd_sales_current_year) * 100
  end

  def open_orders_summary
    Views::OrderAction.find_by_sql("
      SELECT
        SUM(COUNT(DISTINCT ORDNUMBER)) OVER() AS total_orders,
        SUM(ORDAMOUNT) AS total_amount
      FROM OpenOrders
    ").first
  end

  def open_orders_summary_by_years
    Views::OrderAction.find_by_sql("
      SELECT
        YEAR(CONVERT(DATE, CAST(ORDDATE AS VARCHAR(8)), 112)) AS year,
        SUM(ORDAMOUNT) AS total_amount
      FROM OpenOrders
      GROUP BY YEAR(CONVERT(DATE, CAST(ORDDATE AS VARCHAR(8)), 112))
    ")
  end

  # Items ranking
  def ytd_net_sales_ranking
    Views::SalesAnalysisDetails.find_by_sql("
      SELECT
        i.abc_sales_rank,
        SUM(s.YTDNETSALES) AS netsales,
        SUM(s.YTDGROSMARGIN) AS gp_amount,
        (SUM(s.YTDGROSMARGIN)/SUM(s.YTDNETSALES))*100 AS gp,
        CASE
          WHEN i.abc_sales_rank = 'A' THEN '#C98910'
          WHEN i.abc_sales_rank = 'B' THEN '#A8A8A8'
          WHEN i.abc_sales_rank = 'C' THEN '#965A38'
        END AS 'color'
      FROM SalesAnalysisDetails s
      LEFT JOIN ItemsRanking i ON s.ITEMNO = i.item 
      WHERE s.YR = YEAR(GETDATE()) AND i.abc_sales_rank IS NOT NULL
      GROUP BY i.abc_sales_rank
    ")
  end

  def items_ranking_counter(rank)
    Views::ItemRank.select(:abc_sales_rank).where(abc_sales_rank: rank).count
  end

  def items_ranking_sparkline
    Views::ItemRank.select(:abc_sales_rank).group(:abc_sales_rank).map do |rank|
      Views::SalesAnalysisDetails.find_by_sql("
        SELECT
          (SUM(s.YTDNETSALES)/#{ytd_sales_current_year})*100 AS value
        FROM SalesAnalysisDetails s
        LEFT JOIN ItemsRanking i ON s.ITEMNO = i.item 
        WHERE s.YR = YEAR(GETDATE()) AND abc_sales_rank = '#{rank.abc_sales_rank}'
      ").map {|v| v.value.to_i}
    end
  end

  def items_ranking_qty_sparkline 
    ytd_net_sales_ranking.map do |rank|
      items_ranking_counter(rank.abc_sales_rank)
    end
  end

  def items_ranking_inv_sparkline
    Accpac::Iciloc.find_by_sql("
      SELECT
        SUM((QTYONHAND-QTYCOMMIT)*RECENTCOST) AS TOTALCOST,
        r.abc_sales_rank
      FROM ICILOC l
      LEFT JOIN ItemsRanking r ON r.item = l.ITEMNO
      GROUP BY r.abc_sales_rank
    ").map {|v| v.TOTALCOST.to_i}
  end
end
