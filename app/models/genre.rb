class Genre < ApplicationRecord
  has_many :recipes
  
  validates :name, presence: true, length: { in: 2..10 }
end
