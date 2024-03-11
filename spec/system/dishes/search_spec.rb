require 'rails_helper'

RSpec.describe "search", type: :system do
  let!(:ja_dish1) { create(:dish, genre: "和食") }
  let!(:ja_dish2) { create(:dish, genre: "和食") }
  let!(:ch_dish) { create(:dish, genre: "中華") }
  let!(:ja_dishes) { create_list(:dish, 5) }

  context "ジャンルを選択した場合" do
    it "選択したジャンルの料理を表示し、クリックで料理詳細ページに遷移すること" do
      visit root_path
      within(".home_search") do
        select "和食", from: "q[genre_eq]"
        click_button "Search Dish"
      end
      expect(current_path).to eq search_dishes_path
      expect(page).to have_content ja_dish1.name
      expect(page).to have_content ja_dish2.name
      expect(page).not_to have_content ch_dish.name

      click_on ja_dish1.name
      expect(current_path).to eq dish_path(ja_dish1.id)
    end

    it "表示される料理の件数が1ページ6件までとなっていて、それを超えるとページが追加されること" do
      visit root_path
      within(".home_search") do
        select "和食", from: "q[genre_eq]"
        click_button "Search Dish"
      end
      expect(page).to have_selector ".search_dish_name", count: 6
      click_link "次"
      expect(page).to have_selector ".search_dish_name", count: 1
    end
  end

  context "ジャンルを選択していない場合" do
    it "すべての料理が表示できること" do
      visit root_path
      within(".home_search") do
        click_button "Search Dish"
      end
      expect(current_path).to eq search_dishes_path
      expect(page).to have_content ja_dish1.name
      expect(page).to have_content ja_dish2.name
      expect(page).to have_content ch_dish.name
      expect(page).to have_content "全てのジャンルの料理が表示されます。"
    end
  end
end
