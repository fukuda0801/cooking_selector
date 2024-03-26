require 'rails_helper'

RSpec.describe "keyword", type: :system do
  let!(:tag1) { create(:tag, name: "卵", category: "卵") }
  let!(:tag2) { create(:tag, name: "とり肉", category: "肉") }
  let!(:dish1) { create(:dish, name: "オムライス") }
  let!(:dish2) { create(:dish, name: "唐揚げ") }
  let!(:dish3) { create(:dish, name: "親子丼") }
  let!(:egg_dish) { create(:dish_tag, dish: dish1, tag: tag1) }
  let!(:meet_dish) { create(:dish_tag, dish: dish2, tag: tag2) }
  let!(:egg_meet_dish1) { create(:dish_tag, dish: dish3, tag: tag1) }
  let!(:egg_meet_dish2) { create(:dish_tag, dish: dish3, tag: tag2) }

  context "存在する料理名で検索をした場合" do
    before do
      visit root_path
      fill_in "keyword", with: "オム"
      click_on "検索"
    end

    it "検索ワードを含む料理が表示されること" do
      expect(page).to have_content dish1.name
    end

    it "料理名クリックで料理詳細ページに遷移すること" do
      click_on dish1.name
      expect(current_path).to eq dish_path(dish1.id)
    end
  end

  context "存在しない料理名で検索をした場合" do
    it "料理が表示されないこと" do
      visit root_path
      fill_in "keyword", with: "チャーハン"
      click_on "検索"
      expect(page).to have_content "キーワードに一致する料理が見つかりませんでした。"
    end
  end

  context "検索した材料を持つ料理が存在する場合" do
    it "検索ワードの材料を持つ料理が表示されること" do
      visit root_path
      fill_in "keyword", with: "卵"
      click_on "検索"
      expect(page).to have_content dish1.name
    end
  end

  context "未入力で検索ボタンをクリックした場合" do
    it "全ての料理が表示されること" do
      visit root_path
      click_on "検索"
      expect(page).to have_content dish1.name
      expect(page).to have_content dish2.name
      expect(page).to have_content dish3.name
    end
  end

  context "検索結果が6件を超える場合" do
    let!(:carrot_dishes) { create_list(:dish, 7, :with_carrot) }
    it "表示される料理の件数が1ページ6件までとなっていて、それを超えるとページが追加されること" do
      visit root_path
      fill_in "keyword", with: "にんじん"
      click_on "検索"
      expect(page).to have_selector ".condition_dish_name", count: 6
      click_link "次"
      expect(page).to have_selector ".condition_dish_name", count: 1
    end
  end
end
