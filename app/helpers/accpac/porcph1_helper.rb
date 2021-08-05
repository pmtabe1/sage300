module Accpac::Porcph1Helper

  def posted_by(receipt_number, receipt_id)
    document = receipt_number.partition('-').first
    user_id = Ahoy::Event.where("properties ->> 'action' = 'post_receipt' AND properties ->> 'id' = '#{document}'").first.try(:user_id)
    if user_id.present?
      User.find(user_id.to_i).full_name
    else
      Accpac::Porcph2.find(receipt_id).ENTEREDBY
    end
  end

end
