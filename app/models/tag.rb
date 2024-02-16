class Tag < ApplicationRecord
  has_many :dish_tags
  has_many :dishes
end
