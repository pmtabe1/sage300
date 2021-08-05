module Accpac::ArcusHelper
  def sales_by_country_last(country)
    customer = Accpac::Arcus.where(CODECTRY: "#{country.CODECTRY}").all
    Accpac::Oeshdt.where(YR: last_year, CUSTOMER: customer).sum(:FAMTSALES)
  end

  def sales_by_country_current(country)
    customer = Accpac::Arcus.where(CODECTRY: "#{country.CODECTRY}").all
    Accpac::Oeshdt.where(YR: current_year, CUSTOMER: customer).sum(:FAMTSALES)
  end

  # Customer sales until current period
  def customer_avit_deficit(customer)
    customer_sales_last_year = Accpac::Oeshdt.where("PERIOD < ? AND CUSTOMER = ? AND YR = ?",
                                Time.now.to_date.next_month.strftime("%m"),
                                "#{customer.IDCUST}",
                                last_year).sum(:FAMTSALES)
    customer_sales_current_year = Accpac::Oeshdt.where("PERIOD < ? AND CUSTOMER = ? AND YR = ?",
                                  Time.now.to_date.next_month.strftime("%m"),
                                  "#{customer.IDCUST}",
                                  current_year).sum(:FAMTSALES)
    value = customer_sales_current_year - customer_sales_last_year
    if value > 0
      content_tag(:span, "#{number_to_human(value, format: '%n%u', units: { thousand: 'K' })} <i class='fa fa-level-up'></i>".html_safe,
        class: "text-info", rel: "tooltip", 'data-toggle': 'tooltip', 'data-placement': "top", title: number_to_currency(value))
    elsif value < 0
      content_tag(:span, "#{number_to_human(value, format: '%n%u', units: { thousand: 'K' })} <i class='fa fa-level-down'></i>".html_safe,
        class: "text-danger", rel: "tooltip", 'data-toggle': 'tooltip', 'data-placement': "top", title: number_to_currency(value))
    else
      "-"
    end
  end

  def credit_limit_progress_bar(customer)
    limit = (customer.AMTBALDUET/customer.AMTCRLIMT)*100
    case
    when limit < 70
      content_tag(:div, "", style: "width: #{number_to_percentage(limit)}", class: "progress-bar progress-bar-info")
    when limit > 70 && limit < 90
      content_tag(:div, "", style: "width: #{number_to_percentage(limit)}", class: "progress-bar progress-bar-warning")
    when limit > 90
      content_tag(:div, "", style: "width: #{number_to_percentage(limit)}", class: "progress-bar progress-bar-danger")
    end
  end

  def ytd_customer_sales_current_year(customer)
    Accpac::Oeshdt.where("PERIOD <= ? AND YR = ? AND CUSTOMER = ?", Time.now.month, current_year, customer).sum('FAMTSALES - FRETSALES')
  end

  def total_customers_dues
    Accpac::Arcus.where('AMTBALDUET > 0').sum('AMTBALDUET')
  end

  def total_customers_overdues
    Views::UnpaidReceivable.sum('INAMTOVER')
  end

  def customer_sales_rank_color(customer)
    case customer.customers_ranking.ABC_SALES_RANK
    when "A"
      'gold'
    when "B"
      'silver'
    when "C"
      'bronze'
    end
  end

  def customer_margin_rank_color(customer)
    case customer.customers_ranking.ABC_MARGIN_RANK
    when "A"
      'gold'
    when "B"
      'silver'
    when "C"
      'bronze'
    end
  end

  def customer_gross_margin(customer)
    net_sales = Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), CUSTOMER: customer).sum('FAMTSALES - FRETSALES')
    cost_of_sales = Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), CUSTOMER: customer).sum('FCSTSALES')
    gross_margin = ((net_sales - cost_of_sales)/net_sales)*100
  end

  def customer_gross_margin_ytd(customer)
    net_sales = Accpac::Oeshdt.where(YR: current_year, CUSTOMER: customer).sum('FAMTSALES - FRETSALES')
    cost_of_sales = Accpac::Oeshdt.where(YR: current_year, CUSTOMER: customer).sum('FCSTSALES')
    gross_margin = ((net_sales - cost_of_sales)/net_sales)*100
  end

  def open_orders_gross_margin(customer)
    order_amount = customer.order_action.sum(:ORDAMOUNT)
    most_recet_cost = customer.order_action.sum(:MRCAMOUNT)
    gross_margin = ((order_amount - most_recet_cost)/order_amount)*100
  end
end
