class UserDish < ApplicationRecord
  belongs_to :user
  belongs_to :dish

  def self.ransackable_attributes(_auth_object = nil)
    %w[user_id dish_id]
  end
end
