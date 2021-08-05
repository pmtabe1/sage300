module Accpac::IccatgHelper

  # sales area chart
  def sales_category_chart_data
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      {
        ORDDATE: year.to_s,
        FAMTSALES: Accpac::Oeshdt.where("year(YR) = ? AND CATEGORY = ?", year, (@accpac_iccatg.CATEGORY)).sum(:FAMTSALES)
      }
    end
  end

  def active(category)
    if category.INACTIVE == 0
      content_tag(:span, "Active", class: "label label-success")
    else
      content_tag(:span, "Inactive", class: "label label-danger")
    end
  end
end
