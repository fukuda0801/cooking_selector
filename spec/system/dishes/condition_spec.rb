require 'rails_helper'

RSpec.describe "condition", type: :system do
  let!(:tag1) { create(:tag, name: "卵", category: "卵") }
  let!(:tag2) { create(:tag, name: "とり肉", category: "肉") }
  let!(:dish1) { create(:dish, name: "オムライス") }
  let!(:dish2) { create(:dish, name: "唐揚げ") }
  let!(:dish3) { create(:dish, name: "親子丼") }
  let!(:egg_dish) { create(:dish_tag, dish: dish1, tag: tag1) }
  let!(:meet_dish) { create(:dish_tag, dish: dish2, tag: tag2) }
  let!(:egg_meet_dish1) { create(:dish_tag, dish: dish3, tag: tag1) }
  let!(:egg_meet_dish2) { create(:dish_tag, dish: dish3, tag: tag2) }
  let!(:carrot_dishes) { create_list(:dish, 7, :with_carrot) }

  context "材料を選択した場合" do
    it "選択した材料を持つ料理を表示し、クリックで料理詳細ページに遷移する" do
      visit root_path
      within(".home_condition") do
        select "卵", from: "search[tags][卵]"
        click_button "Search Dish"
      end
      expect(current_path).to eq condition_dishes_path
      expect(page).to have_content dish1.name
      expect(page).to have_content dish3.name
      expect(page).not_to have_content dish2.name

      click_on dish1.name
      expect(current_path).to eq dish_path(dish1.id)
    end

    it "材料を複数選択した場合、一つでも選択した材料を持つ料理を表示すること" do
      visit root_path
      within(".home_condition") do
        select "卵", from: "search[tags][卵]"
        select "とり肉", from: "search[tags][肉]"
        click_button "Search Dish"
      end
      expect(current_path).to eq condition_dishes_path
      expect(page).to have_content dish1.name
      expect(page).to have_content dish2.name
      expect(page).to have_content dish3.name
    end

    it "表示される料理の件数が1ページ6件までとなっていて、それを超えるとページが追加されること" do
      visit root_path
      within(".home_condition") do
        select "にんじん", from: "search[tags][野菜]"
        click_button "Search Dish"
      end
      expect(page).to have_selector ".condition_dish_name", count: 6
      click_link "次"
      expect(page).to have_selector ".condition_dish_name", count: 1
    end
  end

  context "材料を選択しなかった場合" do
    it "すべての料理が表示されること" do
      visit root_path
      within(".home_condition") do
        click_button "Search Dish"
      end
      expect(current_path).to eq condition_dishes_path
      expect(page).to have_content dish1.name
      expect(page).to have_content dish2.name
      expect(page).to have_content dish3.name
    end
  end
end
