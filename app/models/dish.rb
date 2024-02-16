class Dish < ApplicationRecord
  has_many :dish_tags
  has_many :tags, through: :dish_tags
  has_many :user_dishes
  has_many :users, through: :user_dishes
  has_one_attached :image
end
