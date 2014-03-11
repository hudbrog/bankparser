class Transaction < ActiveRecord::Base
  belongs_to :category

  def categorize
    hint = Hint.where(regex: self.desc).first
    return false unless hint
    self.update_attributes!(category_id: hint.category_id)
  end
end