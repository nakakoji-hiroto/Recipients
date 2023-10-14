class RecipeComment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  
  validates :comment, presence: true, length: {maximum: 200 }
end
