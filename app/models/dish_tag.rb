class DishTag < ApplicationRecord
  belongs_to :dish
  belongs_to :tag

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at dish_id id tag_id updated_at]
  end
end
