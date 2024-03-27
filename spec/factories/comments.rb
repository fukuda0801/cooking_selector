FactoryBot.define do
  factory :comment do
    content { "美味しかったです。" }
    user
    dish
  end
end
