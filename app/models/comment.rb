class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :dish

  validates :content, presence: true, length: { maximum: 50 }
end
