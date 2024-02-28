require 'rails_helper'

RSpec.describe "UserDishes", type: :system do
  let!(:user) { create(:user) }
  let!(:dishes) { create_list(:dish, 12, :with_image) }
  let!(:cant_dish) { create(:dish) }

  before do
    user.dishes << dishes
    sign_in user
  end

  describe "ユーザーお気に入り料理" do
    it "お気に入り料理が12件までしか登録できないこと" do
      visit dish_path(cant_dish.id)
      click_on "お気に入りに追加"
      expect(page).to have_content "お気に入りは最大12件までです"
      visit favorites_user_path(user.id)
      expect(page).not_to have_content(cant_dish.name)
    end

    it "お気に入り料理クリックで料理詳細ページに遷移すること" do
      visit favorites_user_path(user.id)
      click_on dishes[0].name
      expect(current_path).to eq dish_path(dishes[0].id)
    end
  end
end
