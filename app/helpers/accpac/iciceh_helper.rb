module Accpac::IcicehHelper
  ### STATUS ###
  # 1 = Entered
  # 2 = Posted
  # 3 = Costed
  # 20 = Day End Completed
  def iciceh_status(value)
    if value.STATUS == 1
      content_tag(:span, "#{value.STATUS}", class: "label label-info", rel: "tooltip",
                  'data-toggle': 'tooltip', 'data-placement': "top", title: "Entered")
    elsif value.STATUS == 2
      content_tag(:span, "#{value.STATUS}", class: "label label-info", rel: "tooltip",
                  'data-toggle': 'tooltip', 'data-placement': "top", title: "Posted")
    elsif value.STATUS == 3
      content_tag(:span, "#{value.STATUS}", class: "label label-info", rel: "tooltip",
                  'data-toggle': 'tooltip', 'data-placement': "top", title: "Costed")
    elsif value.STATUS == 20
      content_tag(:span, "#{value.STATUS}", class: "label label-success", rel: "tooltip",
                  'data-toggle': 'tooltip', 'data-placement': "top", title: "Day End Completed")
    end
  end

  # Warehouse Departments
  def departments
    Accpac::Icitemo.find_by_sql(
      "SELECT VALUE FROM ICITEMO
        WHERE OPTFIELD = 'DEPT'
        GROUP BY OPTFIELD, VALUE
        ORDER BY VALUE ASC").map { |d| d.VALUE.gsub(/\s+/, '') }
  end

  # List Internal Usage Order by User Department
  def internal_usage_department(value)
    Accpac::Icitemo.where(ITEMNO: value.ITEMNO.gsub('-', ''), OPTFIELD: "DEPT", VALUE: current_user.department)
  end

  # Item Availability
  def availability(value)
    onhand = Accpac::Iciloc.find(value.ITEMNO.gsub('-', '')).QTYONHAND
    commit = Accpac::Iciloc.find(value.ITEMNO.gsub('-', '')).QTYCOMMIT
    available = (onhand - commit)
  end

end