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
  confirmed_at: Time.now,
  sex: "男"
)

tag_egg = Tag.create!(
  name: "卵",
  category: "卵・乳"
)

image_path = Rails.root.join('app/assets/images/default_dish.jpeg')

dish = Dish.create!(
  name: "オムライス",
  description: "実は日本発祥の料理！！",
  cook_time: 20,
  calorie: 800,
  difficulty: "簡単",
  genre: "洋食",
  category_full_id: "14-121"
)
dish.image.attach(io: File.open(image_path), filename: 'default_dish.jpg', content_type: 'image/jpeg')
dish.tags << tag_egg
