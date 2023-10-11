class RecipeStep < ApplicationRecord
  has_one_attached :image
  belongs_to :recipe
  
  validates :step, presence: true
  validates :explanation, presence: true, length: {in: 2..50 }
end
