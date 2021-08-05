module Accpac::IctrehHelper
  ### STATUS ###
  # 1 = Entered
  # 2 = Posted
  # 3 = Costed
  # 20 = Day End Completed
  def ictreh_status(value)
    if value.STATUS == 1
      content_tag(:span, "Entered")
    elsif value.STATUS == 2
      content_tag(:span, "Posted")
    elsif value.STATUS == 3
      content_tag(:span, "Costed")
    elsif value.STATUS == 20
      content_tag(:span, "Completed")
    end
  end

  # Document Type
  # 1=Transfer
  # 2=Transit Transfer
  # 3=Transit Receipt
  def document_type(value)
    if value.DOCTYPE == 1
      content_tag(:span, "Transfer")
    elsif value.DOCTYPE == 2
      content_tag(:span, "Transit Tarnsfer")
    elsif value.DOCTYPE == 3
      content_tag(:span, "Transit Receipt")
    end
  end

end
