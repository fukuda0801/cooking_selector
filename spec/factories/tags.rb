FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag#{n}" }
    category { "カテゴリ" }
  end
end
