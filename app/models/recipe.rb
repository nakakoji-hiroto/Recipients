class Recipe < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :recipe_marerials, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  
  validates :title, presence: true, length: { in: 2..20 }
  validates :catch_copy, presence: true, length: {maximum: 200 }
  
  def get_recipe_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant( resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0" )
    #image.variant(resize_to_limit: [width, height]).processed
  end
  
end
