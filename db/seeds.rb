# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
AdminUser.create!(email: 'admin@example.com', password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']) if Rails.env.production?

User.create!(
  name: "管理ユーザー",
  email: "user@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.now
  sex: "男"
)

tag_egg = Tag.create!(
  name: "卵",
  category: "食材"
)

dish = Dish.create!(
  name: "オムライス",
  description: "卵をふんだんに使ったオムライス。",
  cook_time: 20,
  calorie: 500,
  difficulty: "初心者",
  genre: "洋食",
  category_full_id: "14-121"
)

dish.tags << tag_egg
