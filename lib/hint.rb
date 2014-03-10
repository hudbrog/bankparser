class Hint < ActiveRecord::Base
  belongs_to :category
  validates_uniqueness_of :regex
end