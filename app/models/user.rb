class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :recipes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)(?=.*?[\W_])[!-~]{8,}+\z/i.freeze
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'パスワードは半角英数記号を各1文字以上含める必要があります', on: :create }
  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :email, presence: true, uniqueness: true
         
  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
end
