module Accpac::ArsapHelper

  # sales by years
  def sales_rep_chart_data
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      {
        ORDDATE: year,
        QTYSOLD: Accpac::Oeshdt.where("year(YR) = ? AND SALESPER = ?", year, (@accpac_arsap.CODESLSP)).sum(:QTYSOLD),
        FAMTSALES: Accpac::Oeshdt.where("year(YR) = ? AND SALESPER = ?", year, (@accpac_arsap.CODESLSP)).sum(:FAMTSALES)
      }
    end
  end

  # sales by periods
  def monthly_sales
    (1..12).map do |month|
      {
        MONTHS: month,
        CURRENT: Accpac::Oeshdt.where("PERIOD = ? AND SALESPER = ? AND YR = ?", month, (@accpac_arsap.CODESLSP), current_year).sum(:FAMTSALES),
        LAST: Accpac::Oeshdt.where("PERIOD = ? AND SALESPER = ? AND YR = ?", month, (@accpac_arsap.CODESLSP), last_year).sum(:FAMTSALES)
      }
    end
  end

  # Sales until current period
  def avit_deficit(sales_rep)
    sales_rep_last_year = Accpac::Oeshdt.where("PERIOD < ? AND SALESPER = ? AND YR = ?",
                          Time.now.to_date.next_month.strftime("%m"),
                          "#{sales_rep.CODESLSP}",
                          last_year).sum(:FAMTSALES)
    sales_rep_current_year = Accpac::Oeshdt.where("PERIOD < ? AND SALESPER = ? AND YR = ?",
                              Time.now.to_date.next_month.strftime("%m"),
                              "#{sales_rep.CODESLSP}",
                              current_year).sum(:FAMTSALES)
    value = sales_rep_current_year - sales_rep_last_year
    if value > 0
      content_tag(:span, "#{number_to_human(value, format: '%n%u', units: { thousand: 'K' })} <i class='fa fa-level-up'></i>".html_safe,
        class: "text-navy", rel: "tooltip", 'data-toggle': 'tooltip', 'data-placement': "top", title: number_to_currency(value))
    elsif value < 0
      content_tag(:span, "#{number_to_human(value, format: '%n%u', units: { thousand: 'K' })} <i class='fa fa-level-down'></i>".html_safe,
        class: "text-danger", rel: "tooltip", 'data-toggle': 'tooltip', 'data-placement': "top", title: number_to_currency(value))
    else
      "-"
    end
  end

  def sales_person_customers_overdues(id)
    Views::UnpaidReceivable.find_by_sql("
    SELECT
      IDCUST, NAMECUST, SUM(INAMTOVER) AS INAMTOVER
      FROM UnPaidReceivable
      WHERE CODESLSP1 = '#{id}'
        OR CODESLSP2 = '#{id}'
        OR CODESLSP3 = '#{id}'
        OR CODESLSP4 = '#{id}'
      GROUP BY IDCUST, NAMECUST
      HAVING SUM(INAMTOVER) > 0
    ")
  end

end
