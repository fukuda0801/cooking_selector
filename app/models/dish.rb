class Dish < ApplicationRecord
  has_many :dish_tags, dependent: :destroy
  has_many :tags, through: :dish_tags
  has_many :user_dishes
  has_many :users, through: :user_dishes
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 25}
  validates :cook_time, presence: true
  validates :calorie, presence: true
  validates :difficulty, presence: true
  validates :genre, presence: true

  def self.random
    order("RAND()").first
  end

  def self.search_by_tag_names(tag_names)
    return Dish.all if tag_names.blank?
    Dish.joins(:tags).where(tags: { name: tag_names }).distinct
  end

  # Ransackで検索可能な関連付けを指定
  def self.ransackable_associations(auth_object = nil)
    ['tags']
  end

  # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    %w[name description cook_time calorie genre]
  end
end
