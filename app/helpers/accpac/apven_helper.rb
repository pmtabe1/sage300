module Accpac::ApvenHelper
  def purchase_last_year(vendor, period)
    Accpac::Pohsth.where("VENDOR = ? AND FISCYEAR = ? AND FISCPERIOD = ?", vendor, last_year, period).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def purchase_current_year(vendor, period)
    Accpac::Pohsth.where("VENDOR = ? AND FISCYEAR = ? AND FISCPERIOD = ?", vendor, current_year, period).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def current_vs_last(vendor, period)
    purchase_current_year(vendor, period) - purchase_last_year(vendor, period)
  end

  # Year to date (YTD) purchases
  def purchase_ytd_last_year(vendor, period)
    Accpac::Pohsth.where("VENDOR = ? AND FISCYEAR = ? AND FISCPERIOD <= ?", vendor, last_year, period).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def purchase_ytd_current_year(vendor, period)
    Accpac::Pohsth.where("VENDOR = ? AND FISCYEAR = ? AND FISCPERIOD <= ?", vendor, current_year, period).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def purchase_ytd_percentage(vendor, period)
    if purchase_ytd_last_year(vendor, period) == 0 || nil?
      if purchase_ytd_current_year(vendor, period).nil?
        percentage = (purchase_ytd_current_year(vendor, period) / purchase_ytd_current_year(vendor, period))*100
      else
        percentage = 0.00
      end
    else
      percentage = (purchase_ytd_current_year(vendor, period) / purchase_ytd_last_year(vendor, period))*100
    end
    if percentage-100 > 0
      "<div class='stat-percent'>#{number_to_percentage(percentage-100, precision: 0)} <i class='fa fa-level-up text-navy'></i></div>
      <div class='progress progress-mini'>
        <div style='width: #{number_to_percentage(percentage-100, precision: 0)};' class='progress-bar'></div>
      </div>".html_safe
    else
      "<div class='stat-percent'>#{number_to_percentage(100-percentage, precision: 0)} <i class='fa fa-level-down text-danger'></i></div>
      <div class='progress progress-mini'>
        <div style='width: #{number_to_percentage(100-percentage, precision: 0)};' class='progress-bar progress-bar-danger'></div>
      </div>".html_safe
    end
  end

  def purchase_ytd_diff(vendor, period)
    purchase_ytd_current_year(vendor, period) - purchase_ytd_last_year(vendor, period)
  end

  def ytd_payments(vendor)
    Accpac::Apobl.where(IDVEND: vendor, FISCYR: current_year, TXTTRXTYPE: 10..11).sum("ABS(AMTINVCTC)")
  end

  def total_vendors_dues
    Accpac::Apven.where('AMTBALDUET > 0').sum('AMTBALDUET')
  end
end
