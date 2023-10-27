class RecipeStep < ApplicationRecord
  has_one_attached :image
  belongs_to :recipe
  
  validates :step, presence: true
  validates :explanation, presence: true, length: {in: 2..50 }
  
  def get_recipe_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant( resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0" )
  end
end
