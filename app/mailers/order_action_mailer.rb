class OrderActionMailer < ActionMailer::Base
  include ApplicationHelper

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV['MANDRILL_API_KEY'])
  end

  def order_action(row, counter, rep_name)
    users = User.where(arsap: row.SALESREP).pluck(:id)

    recipients = convert_users_to_mandrill_recipients(users)
    merge_vars = convert_users_to_mandrill_merge_fields(users)
    template_content = []
    template_name = "orders-to-fulfill"
    message = {
      to: recipients,
      subject: "Order Action Notification #{Time.now.strftime("%Y/%m/%d")}",
      merge_vars: merge_vars,
      preserve_recipients: false,
      global_merge_vars: [
        {name: "SALESREP", content: row.SALESREP},
        {name: "NAME", content: rep_name},
        {name: "COUNTER", content: counter},
        {name: "TOTAL", content: ActiveSupport::NumberHelper.number_to_currency(row.TOTAL, precision: 2)},
        {name: "URL", content: company_url},
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

  def convert_copy_to_mandrill_recipients(supply_chain_event)
    supply_chain_event.copy_to.split(',').map do |email|
      {:email => email}
    end
  end

  # Backorders Notification
  def backorder_action(counter, amount)
    #User.where("preferences ->> 'dept_area' = 'purchasing'").pluck(:fname)
    template_name = "backorder-action"
    template_content = []
    message = {
      to: [{email: "purchasing@vertilux.com"}],
      subject: "Backorder Action Notification #{Time.now.strftime("%Y/%m/%d")}",
      merge_vars: [
        { rcpt: "purchasing@vertilux.com",
          vars: [
            {name: "COUNTER", content: counter},
            {name: "AMOUNT", content: ActiveSupport::NumberHelper.number_to_currency(amount)}
          ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

end
