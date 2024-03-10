class User < ApplicationRecord
  has_many :user_dishes, dependent: :destroy
  has_many :dishes, through: :user_dishes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true, length: { maximum: 20 }
  validates :password, format: { with: /\A[a-zA-Z0-9]+\z/, message: 'は半角英数字で入力してください。' }
  validates :sex, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id email name sex created_at updated_at]
  end

  def self.guest
    find_or_create_by!(email: 'guest1@example.com') do |user|
      user.password = SecureRandom.alphanumeric(8)
      user.name = "ゲストユーザー"
      user.sex = "未設定(ゲスト用)"
      user.confirmed_at = Time.zone.now
    end
  end
end
