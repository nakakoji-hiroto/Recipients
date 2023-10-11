class RecipeMaterial < ApplicationRecord
  belongs_to :recipe
  validates :name, presence: true, length: { in: 2..20 }
  validates :quantity, presence: true, length: {in: 2..20 }
end
