class PostReceiptWorker
  include Sidekiq::Worker

  def perform(id, vendor, number, description)
    PostReceiptMailer.submit_receipt(id, vendor, number, description).deliver
  end
end
