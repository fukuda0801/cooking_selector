class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:email] # 管理者ログインの認証キー設定(userモデルでは:nameにしている)

  # 管理者画面検索許可
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email created_at updated_at]
  end
end
