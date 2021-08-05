class CustomerDuesMailer < ActionMailer::Base
  include Accpac::ArsapHelper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV['MANDRILL_API_KEY'])
  end

  def customer_overdues(sales_person_id, sales_person_name)
    users = User.where(arsap: sales_person_id).pluck(:id)

    recipients = convert_users_to_mandrill_recipients(users)
    merge_vars = convert_users_to_mandrill_merge_fields(users)

    template_name = "customers-overdues"
    template_content = []
    message = {
      to: recipients,
      subject: "Customer Dues",
      preserve_recipients: false,
      auto_text: true,
      inline_css: true,
      merge: true,
      merge_language: "handlebars",
      merge_vars: merge_vars,
      global_merge_vars: [
        { name: "sales_person", content: sales_person_name },
        { name: "total_amount", content: number_to_currency(sales_person_customers_overdues(sales_person_id).map(&:INAMTOVER).inject(:+)) },
        { name: "address", content: strip_tags(company_address) },
        {
          name: "customers",
          content: sales_person_customers_overdues(sales_person_id).map do |customer|
            {
              customer_id: customer.IDCUST,
              customer_name: customer.NAMECUST,
              amount: number_to_currency(customer.INAMTOVER, precision: 2, delimiter: ",")
            }
          end
        }
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
