class PostInvoiceWorker
  include Sidekiq::Worker

  def perform(invoice, customer)
    PostInvoiceMailer.submit_receipt(invoice, customer).deliver
  end
end
