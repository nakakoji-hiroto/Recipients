class Recipe < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  belongs_to :genre
  has_many :recipe_materials, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :recipe_tags,dependent: :destroy
  has_many :tags,through: :recipe_tags
  has_many :recipe_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  validates :title, presence: true, length: { in: 2..20 }
  validates :catch_copy, presence: true, length: {maximum: 50 }

  def get_recipe_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant( resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0" )
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_recipe_tag = Tag.find_or_create_by(name: new)
      self.tags << new_recipe_tag
    end
  end
  
  def difficulty_judgment #difficultyカラムのvalueを対応する文字列に変換する
    case self.difficulty
      when "1"
        "易しい"
      when "2"
       "やや易しい"
      when "3"
        "普通"
      when "4"
        "やや難しい"
      when "5"
        "難しい"
      else
        "未設定"
    end
  end

end
