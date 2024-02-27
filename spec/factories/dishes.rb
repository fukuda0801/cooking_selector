FactoryBot.define do
  factory :dish do
    sequence(:name) { |n| "name#{n}" }
    description { "これはテスト用の料理です。" }
    cook_time { 30 }
    calorie { 200 }
    difficulty { "普通" }
    genre { "和食" }

    trait :with_carrot do
      after(:create) do |dish|
        carrot_tag = Tag.find_or_create_by(name: "にんじん", category: "野菜")
        create(:dish_tag, dish: dish, tag: carrot_tag)
      end
    end
  end
end
