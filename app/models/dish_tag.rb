class DishTag < ApplicationRecord
  belongs_to :dish
  belongs_to :tag

  def self.ransackable_attributes(auth_object = nil)
    # 検索に利用したい属性名の配列
    %w[created_at dish_id id tag_id updated_at]
  end
end
