module Accpac::IcasenHelper

  # Transaction Type
  # 1=Transfer
  # 2=Transit Transfer
  def assembly_tran_type(value)
    case value
    when 1
      "Master Item"
    when 2
      "Component Item"
    end
  end

end
