require 'rails_helper'

RSpec.describe "UserDishes", type: :system do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:dishes) { create_list(:dish, 12, :with_image) }
  let!(:another_dish) { create(:dish) }

  before do
    user.dishes << dishes
    another_user.dishes << another_dish
  end

  describe "ユーザーお気に入り料理" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "お気に入り料理が12件までしか登録できないこと" do
        visit dish_path(another_dish.id)
        click_on "お気に入りに追加"
        expect(page).to have_content "お気に入りは最大12件までです"
        visit favorites_user_path(user.id)
        expect(page).not_to have_content another_dish.name
      end

      it "お気に入り料理クリックで料理詳細ページに遷移すること" do
        visit favorites_user_path(user.id)
        click_on dishes[0].name
        expect(current_path).to eq dish_path dishes[0].id
      end

      it "他のユーザーのidを使用してお気に入り料理ページにアクセスしても、ログインしているユーザーの情報が表示されること" do
        visit favorites_user_path(another_user.id)
        expect(page).not_to have_content another_dish.name
        expect(page).to have_content dishes[0].name
      end
    end

    context "ログインしていない場合" do
      it "ログインユーザーのidを使用してお気に入り料理ページにアクセスしても、ログイン画面に遷移すること" do
        visit favorites_user_path(user.id)
        expect(current_path).to eq new_user_session_path
      end

      it "お気に入りページへのリンクが表示されないこと" do
        visit root_path
        expect(page).not_to have_content "お気に入り料理"
      end
    end
  end
end
