module Accpac::SiaudHelper

  # •If you will choose ‘0’ then the system will replace the old Item Number with
  #   a new Item Number in your Sage 300 ERP data files and an old Item Number will
  #   be removed from your database.
  # •If you will choose ‘1’ then the system will merge the history, data records
  #   and transactions of the old existing item into the new existing Item and
  #   remove the source item from the sage records.
  # •If you will choose ‘2’ then the system will quickly establishes a new Item
  #   based on an existing Item.

  def type_action(change)
    if change.ACTION == 0
      "Old Item Number will be removed"
    elsif change.ACTION == 1
      "The system will merge the history"
    elsif change.ACTION == 2
      "Quickly establishes a new Item based on an existing Item"
    end
  end
end
