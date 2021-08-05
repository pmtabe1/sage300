class LowStockItemsMailer < ActionMailer::Base
  include Accpac::IcitemHelper
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV['MANDRILL_API_KEY'])
  end

  def low_stock
    users = User.where("preferences ->> 'dept_area' = 'purchasing'").pluck(:id)
    recipients = convert_users_to_mandrill_recipients(users)
    merge_vars = convert_users_to_mandrill_merge_fields(users)

    template_name = "low-stock"
    template_content = []
    message = {
      to: recipients,
      subject: "Items with low stock.",
      preserve_recipients: false,
      auto_text: true,
      inline_css: true,
      merge: true,
      merge_language: "handlebars",
      merge_vars: merge_vars,
      global_merge_vars: [
        { name: "description", content: "Items A" },
        { name: "address", content: strip_tags(company_address) },
        {
          name: "products_a",
          content: low_stock_items.where(abc_sales_rank: 'A').map do |i|
            {
              item: i.FMTITEMNO,
              description: i.DESC,
              dense: i.dense_sales_rank,
              quantity: number_with_precision(i.COVERAGE, precision: 1)
            }
          end
        },
        { name: "products_b", content: low_stock_items.where(abc_sales_rank: 'B').count },
        { name: "products_c", content: low_stock_items.where(abc_sales_rank: 'C').count }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def convert_users_to_mandrill_recipients(ids)
    ids.map do |id|
      user = User.find(id)
      {:email => user.email}
    end
  end

  def convert_users_to_mandrill_merge_fields(ids)
    ids.map do |id|
      user = User.find(id)
      {:rcpt => user.email}
    end
  end
end
