class Dish < ApplicationRecord
  has_many :dish_tags
  has_many :tags, through: :dish_tags
  has_many :user_dishes
  has_many :users, through: :user_dishes
  has_one_attached :image

  def self.random
    order("RAND()").first
  end

  def self.search_by_tag_names(tag_names)
    return Dish.all if tag_names.blank?
    Dish.joins(:tags).where(tags: { name: tag_names }).distinct
  end

  # Ransackで検索可能な関連付けを指定
  def self.ransackable_associations(auth_object = nil)
    # 検索に含めたい関連付けの名前の配列
    ['tags']
  end

  # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    # 検索に含めたい属性の名前の配列
    %w[name description cook_time calorie genre]
  end
end
