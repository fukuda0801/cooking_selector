require 'rails_helper'

RSpec.describe "random", type: :system do
  let!(:user) { create(:user) }
  let!(:dish1) { create(:dish, :with_image, name: "オムライス", category_full_id: "30") }
  let!(:dish2) { create(:dish, :with_image, name: "親子丼", category_full_id: "30") }
  let!(:tag) { create(:tag) }
  let!(:dish_tag1) { create(:dish_tag, dish: dish1, tag: tag) }
  let!(:dish_tag2) { create(:dish_tag, dish: dish2, tag: tag) }

  describe "お気に入りボタン" do
    context "ユーザーがログイン済みで、表示している料理がお気に入り登録していない場合" do
      it "お気に入りリンク表示、リンククリックでお気に入り追加できること" do
        sign_in user
        visit random_dishes_path
        expect(page).to have_content(dish1.name).or have_content(dish2.name)
        initial_favorites_count = user.dishes.count
        expect(page).not_to have_content "お気に入りから削除"
        click_on "お気に入りに追加"
        expect(user.dishes.count).to eq initial_favorites_count + 1
      end
    end

    context "ユーザーがログイン済みで、表示している料理がお気に入り登録済みである場合" do
      it "お気に入りから削除リンク表示、リンククリックでお気に入りから削除できること" do
        user.dishes << [dish1, dish2]
        initial_favorites_count = user.dishes.count
        sign_in user
        visit random_dishes_path
        expect(page).not_to have_content "お気に入りに追加"
        click_on "お気に入りから削除"
        expect(page).to have_content "お気に入りから削除しました"
        expect(user.dishes.count).to eq initial_favorites_count - 1
      end
    end

    context "ユーザーがログインしていない場合" do
      it "お気に入りボタンおよび削除ボタンが表示されていないこと" do
        visit random_dishes_path
        expect(page).not_to have_content "お気に入りに追加"
        expect(page).not_to have_content "お気に入りから削除"
      end
    end
  end

  describe "料理詳細ページ表示" do
    it "料理詳細が表示されること" do
      visit random_dishes_path
      expect(page).to have_selector "img[src*='test.jpg']"
      expect(page).to have_content(dish1.name).or have_content(dish2.name)
      expect(page).to have_content(dish1.genre).or have_content(dish2.genre)
      expect(page).to have_content(dish1.difficulty).or have_content(dish2.difficulty)
      expect(page).to have_content(dish1.cook_time).or have_content(dish2.cook_time)
      expect(page).to have_content(dish1.calorie).or have_content(dish2.calorie)
      expect(page).to have_content tag.name
      expect(page).to have_content(dish1.favorites_count).or have_content(dish2.favorites_count)
      expect(page).to have_content(dish1.popularity_rank).or have_content(dish2.popularity_rank)
      expect(page).to have_content(dish1.description).or have_content(dish2.description)
    end
  end

  describe "楽天レシピAPI" do
    before do
      @rakuten_service_mock = instance_double(RakutenRecipeService)
      allow(RakutenRecipeService).to receive(:new).and_return(@rakuten_service_mock)
    end
    context "関連レシピがある場合" do
      it "関連レシピが表示されること" do
        allow(@rakuten_service_mock).to receive(:fetch_recipes).with("30").and_return({
          "result" => [
            { "recipeTitle" => "テストレシピ1", "recipeUrl" => "http://example.com/recipe1" },
            { "recipeTitle" => "テストレシピ2", "recipeUrl" => "http://example.com/recipe2" }
          ]
        })
        visit random_dishes_path
        expect(page).to have_content "テストレシピ1"
        expect(page).to have_content "テストレシピ2"
      end
    end

    context "関連レシピがない場合" do
      it "レシピが見つかりませんでしたと表示されること" do
        allow(@rakuten_service_mock).to receive(:fetch_recipes).with("30").and_return({ "result" => [] })
        visit random_dishes_path
        expect(page).to have_content "レシピが見つかりませんでした"
      end
    end
  end
end
