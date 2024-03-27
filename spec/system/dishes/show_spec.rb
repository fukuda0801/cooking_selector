require 'rails_helper'

RSpec.describe "show", type: :system do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:dish) { create(:dish, :with_image, name: "オムライス", category_full_id: "30") }
  let!(:tag) { create(:tag) }
  let!(:dish_tag) { create(:dish_tag, dish: dish, tag: tag) }
  let!(:comment) { create(:comment, user: user, dish: dish) }

  describe "お気に入りボタン" do
    context "ユーザーがログイン済みで、表示している料理がお気に入り登録していない場合" do
      it "お気に入りリンク表示、リンククリックでお気に入り追加できること" do
        sign_in user
        visit dish_path(dish.id)
        expect(page).not_to have_content "お気に入りから削除"
        click_on "お気に入りに追加"
        expect(user.dishes).to include dish
      end
    end

    context "ユーザーがログイン済みで、表示している料理がお気に入り登録済みである場合" do
      it "お気に入りから削除リンク表示、リンククリックでお気に入りから削除できること" do
        user.dishes << dish
        sign_in user
        visit dish_path(dish.id)
        expect(page).not_to have_content "お気に入りに追加"
        click_on "お気に入りから削除"
        expect(page).to have_content "お気に入りから削除しました"
      end
    end

    context "ユーザーがログインしていない場合" do
      it "お気に入りボタンおよび削除ボタンが表示されていないこと" do
        visit dish_path(dish.id)
        expect(page).not_to have_content "お気に入りに追加"
        expect(page).not_to have_content "お気に入りから削除"
      end
    end
  end

  describe "料理詳細ページ表示" do
    before do
      visit dish_path(dish.id)
    end
    it "料理詳細が表示されること" do
      expect(page).to have_selector "img[src*='test.jpg']"
      expect(page).to have_content dish.name
      expect(page).to have_content dish.genre
      expect(page).to have_content dish.difficulty
      expect(page).to have_content dish.cook_time
      expect(page).to have_content dish.calorie
      expect(page).to have_content tag.name
      expect(page).to have_content dish.favorites_count
      expect(page).to have_content dish.popularity_rank
      expect(page).to have_content dish.description
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
        visit dish_path(dish.id)
        expect(page).to have_content "テストレシピ1"
        expect(page).to have_content "テストレシピ2"
      end
    end

    context "関連レシピがない場合" do
      it "レシピが見つかりませんでしたと表示されること" do
        allow(@rakuten_service_mock).to receive(:fetch_recipes).with("30").and_return({ "result" => [] })
        visit dish_path(dish.id)
        expect(page).to have_content "レシピが見つかりませんでした"
      end
    end
  end

  describe "コメント機能" do
    context "ログインしている場合" do
      it "コメントを投稿できること" do
        sign_in user
        visit dish_path(dish.id)
        fill_in 'comment_content', with: "美味しい"
        click_on "投稿する"
        within('.comment_main') do
          expect(page).to have_content user.name
          expect(page).to have_content "美味しい"
        end
      end

      it "ログインしているユーザーが他のユーザーの投稿を削除できないこと" do
        sign_in another_user
        visit dish_path(dish.id)
        expect(page).not_to have_content "削除"
      end

      it "ログインしているユーザーが投稿したコメントのみ削除できること" do
        sign_in user
        visit dish_path(dish.id)
        click_on "削除"
        expect(page).to have_content "コメントはまだありません。"
      end
    end

    context "ログインしていない場合" do
      it "コメントを投稿できないこと" do
        visit dish_path(dish.id)
        expect(page).to have_content "コメントを投稿するにはログインが必要です。"
      end

      it "他のユーザーが投稿した内容を閲覧できること" do
        visit dish_path(dish.id)
        expect(page).to have_content "美味しかったです。"
      end
    end
  end
end
