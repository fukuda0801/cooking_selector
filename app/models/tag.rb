class Tag < ApplicationRecord
  has_many :dish_tags, dependent: :destroy
  has_many :dishes

  validates :name, presence: true
  validates :category, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name category]
  end
end
