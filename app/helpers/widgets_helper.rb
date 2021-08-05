module WidgetsHelper
  # Backorders
  def backorders_counter
    Views::OrderAction.backorder.count
  end

  def fulfillable_counter
    Views::OrderAction.fulfillable.count
  end

  def purchase_orders_opened_counter
    Accpac::Poporh1.open.count
  end

  def customers_ytd_payments(customer)
    number_to_currency(customer.arcsm.where(CNTYR: current_year).sum(:AMTPAYMHC), precision: 2)
  end

  def customers_debts_list
    Accpac::Arcus.find_by_sql("
      SELECT
          c.IDCUST, c.NAMECUST, c.AMTBALDUET, SUM(d.INAMTOVER) AS INAMTOVER
      FROM ARCUS c
      JOIN un_paid_receivables d ON c.IDCUST = d.IDCUST
      WHERE AMTBALDUET > 0
      GROUP BY c.IDCUST, c.NAMECUST, c.AMTBALDUET
      ORDER BY INAMTOVER DESC"
    )
  end

  def ave_daily_sales_current_year
    days = Accpac::Oeshdt.where(YR: current_year).distinct.count(:TRANDATE)
    amount = Accpac::Oeshdt.where(YR: current_year).sum("FAMTSALES - FRETSALES")
    if days == 0 
      average = amount/1
    else
      average = amount/days
    end
  end

  def ave_daily_sales_last_year
    days = Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", (Time.now-1.year).strftime("%Y%m%d"), last_year).distinct.count(:TRANDATE)
    amount = Accpac::Oeshdt.where("TRANDATE <= ? AND YR = ?", (Time.now-1.year).strftime("%Y%m%d"), last_year).sum("FAMTSALES - FRETSALES")
    if days == 0 
      average = amount/1
    else
      average = amount/days
    end
  end

  def daily_sales_diff
    diff = ave_daily_sales_current_year - ave_daily_sales_last_year
    if ave_daily_sales_last_year == 0
      percentage = (ave_daily_sales_current_year / 1)*100
    else
      percentage = (ave_daily_sales_current_year / ave_daily_sales_last_year)*100
    end
    if percentage-100 > 0
      "<h2 class='no-margins'>#{number_to_currency(diff, precision: 0)} </h2>
      <small>Daily sales difference</small>
      <div class='stat-percent'>#{number_to_percentage(percentage-100, precision: 2)} <i class='fa fa-level-up text-info'></i></div>
      <div class='progress progress-mini'>
        <div style='width: #{number_to_percentage(percentage-100, precision: 2)};' class='progress-bar progress-bar-info'></div>
      </div>".html_safe
    else
      "<h2 class='no-margins'>#{number_to_currency(diff, precision: 0)} </h2>
      <small>Daily sales difference</small>
      <div class='stat-percent'>#{number_to_percentage(100-percentage, precision: 2)} <i class='fa fa-level-down text-danger'></i></div>
      <div class='progress progress-mini'>
        <div style='width: #{number_to_percentage(100-percentage, precision: 2)};' class='progress-bar progress-bar-danger'></div>
      </div>".html_safe
    end
  end
end
