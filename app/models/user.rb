class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :recipe_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  has_many :active_relationships, class_name: "UserRelationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "UserRelationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followeds, through: :passive_relationships, source: :follower
  
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)(?=.*?[\W_])[!-~]{8,}+\z/i.freeze
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'は半角英数記号を各1文字以上含める必要があります', on: :create }
  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :email, presence: true, uniqueness: true

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end
end
