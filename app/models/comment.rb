class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :dish

  validates :content, presence: true, length: { maximum: 50 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[content user_id dish_id]
  end
end
