FactoryBot.define do
  factory :dish do
    sequence(:name) { |n| "name#{n}" }
    description { "これはテスト用の料理です。" }
    cook_time { 30 }
    calorie { 200 }
    difficulty { "普通" }
    genre { "和食" }
  end
end
