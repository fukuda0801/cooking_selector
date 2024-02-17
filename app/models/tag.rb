class Tag < ApplicationRecord
  has_many :dish_tags
  has_many :dishes

  def self.ransackable_attributes(auth_object = nil)
    %w[name category]
  end
end
