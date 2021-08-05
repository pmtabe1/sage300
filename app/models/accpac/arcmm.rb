# Sage300 Customer Comments table.
# Primary key: CNTUNIQ (Comment Number).
class Accpac::Arcmm < ActiveRecord::Base
  self.table_name  = 'ARCMM'
  self.primary_key = 'CNTUNIQ'

  # Association with customers and comment type.
  belongs_to :arcus, foreign_key: 'IDCUST', class_name: "Arcus"
  belongs_to :arcmm, foreign_key: 'CMNTTYPE'

  # Comments ara devided into 10 columns so we created this 
  # method to group all of them into one called all_comments,
  # to easy be called from the views.
  def all_comments
    "#{self.TEXTCMNT1} #{self.TEXTCMNT2} #{self.TEXTCMNT3} #{self.TEXTCMNT4} #{self.TEXTCMNT5} #{self.TEXTCMNT6} #{self.TEXTCMNT7} #{self.TEXTCMNT8} #{self.TEXTCMNT9} #{self.TEXTCMNT10}"
  end

  # This method helps us mimic the sage300 composition id.
  def comp_id
    "#{self.IDCUST.squish}_#{self.AUDTDATE.to_i}_#{self.AUDTTIME.to_i}"
  end

  # Callback to set blank comments as default for all not null
  # columns.
  before_save :default_text2, :default_text3, :default_text4, :default_text5, :default_text6, :default_text7, :default_text8, :default_text9, :default_text10, :default_revcom

  def default_text2
    self.TEXTCMNT2 ||= ''
  end

  def default_text3
    self.TEXTCMNT3 ||= ''
  end

  def default_text4
    self.TEXTCMNT4 ||= ''
  end

  def default_text5
    self.TEXTCMNT5 ||= ''
  end

  def default_text6
    self.TEXTCMNT6 ||= ''
  end

  def default_text7
    self.TEXTCMNT7 ||= ''
  end

  def default_text8
    self.TEXTCMNT8 ||= ''
  end

  def default_text9
    self.TEXTCMNT9 ||= ''
  end

  def default_text10
    self.TEXTCMNT10 ||= ''
  end

  def default_revcom
    self.REVCOM ||= 999
  end
end
