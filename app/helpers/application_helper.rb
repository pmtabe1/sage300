module ApplicationHelper

  # SEO Configuration | Title
  def title(title = nil)
    if title.present?
      content_for :title, title
    else
      content_for?(:title) ? APP_CONFIG['default_title'] + ' | ' + content_for(:title) : APP_CONFIG['default_title']
    end
  end

  def company_id
    info = YAML.load_file("#{Rails.root.to_s}/config/database.yml")
    database = info[Rails.env]["database"]
  end

  def company_name
    Accpac::Cscom.find(company_id).LEGALNAME
  end

  def company_address
    "<address>
      <strong>#{Accpac::Cscom.find(company_id).LEGALNAME}</strong><br>
      #{Accpac::Cscom.find(company_id).address}
    </address>".html_safe
  end

  def company_currency
    Accpac::Cscom.find(company_id).HOMECUR
  end

  def company_country_code
    Accpac::Cscom.find(company_id).CNTRYCODE
  end

  def company_url
    Accpac::Cscom.find(company_id).ADDR04.squish
  end

  def company_logo(px)
    image_tag asset_path("logos/#{company_id.downcase}.png"), height: px
  end

  # current year
  def current_year
    Time.now.in_time_zone('Eastern Time (US & Canada)').strftime("%Y")
  end

  def current_period
    Time.now.in_time_zone('Eastern Time (US & Canada)').strftime("%m")
  end

  def current_days
    (Time.now.to_date - Time.now.beginning_of_year.to_date).to_i
  end

  def format_period(m)
    case m.to_s.length
    when 1
      "0#{m}"
    else
      m.to_s
    end
  end

  # last year
  def last_year
    Time.now.strftime("%Y").to_i - 1
  end

  def year_to_date_last_year
    Time.now.strftime("#{last_year}%m%d")
  end

  def years
    5.year.ago.to_date.year..Time.now.year
  end

  def months
    1..12
  end

  # Menu Navigation
  def home_dashboard
    if params[:action] == "dashboard"
      "active"
    end
  end

  # Date & Time
  def glob_date_time(value)
    date = value.AUDTDATE.to_s.insert(4, '-').insert(7, '-')
    time = value.AUDTTIME.to_s.insert(2, ':').insert(5, ':')[0..-3]
    date_time = ((date + " " + time).to_datetime-4.hours)
  end

  def to_date_helper(date)
    date.to_i.to_s.to_date unless date.nil? || date == 0
  end

  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      content_tag(:li, :class => "active") do
        link_to( text, link)
      end
    else
      content_tag(:li) do
        link_to( text, link)
      end
    end
  end

  # Horizontal Scrolling
  def horizontal_scroll
    if controller_name == "shipping_references" && params[:action] == "board"
      'style="overflow-x-scroll; overflow-y: hidden;"'.html_safe
    end
  end

  def current_browser
    if browser.edge? || browser.ie?
      content_tag(:div, "You're using #{browser.name}. We recommend Chrome, Firefox or Safari.", class: "alert alert-warning text-center", style: "margin-bottom: 0px")
    elsif browser.modern? == false
      content_tag(:div, "You're running an old version of #{browser.name} (#{browser.version}). Please consider to update it.", class: "alert alert-warning text-center", style: "margin-bottom: 0px")
    end
  end

  def plural_resource_name(resource_class)
    resource_class.model_name.human
  end

  def liquidize(content, arguments)
    raw(Liquid::Template.parse(content).render(arguments, :filters => [LiquidFilters]))
  end
end
