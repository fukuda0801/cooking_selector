FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:name) { |n| "user_#{n}" }
    password { 'password' }
    password_confirmation { 'password' }
    sex { '男性' }
    confirmed_at { Time.zone.now }
  end
end
