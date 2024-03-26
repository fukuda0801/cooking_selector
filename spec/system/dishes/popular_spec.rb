require 'rails_helper'

RSpec.describe "popular", type: :system do
  let!(:dishes) { create_list(:user_dish, 10) }
  let!(:not_popular_dish) { create(:dish) }
  let(:first_dish) { dishes.first.dish }

  before do
    visit root_path
    within(".home_popular") do
      click_on "Search Dish"
    end
  end

  describe "ランキングページ情報" do
    it "人気ランキングトップ10が表示されていること" do
      dishes.each do |user_dish|
        expect(page).to have_content user_dish.dish.name
      end
      expect(page).not_to have_content not_popular_dish.name
    end

    it "ランキングページに料理情報が記載されていること" do
      expect(page).to have_content first_dish.name
      expect(page).to have_content first_dish.favorites_count
      expect(page).to have_content first_dish.description
    end

    it "ランキングページのこちらへをクリックで対応する料理の詳細ページに遷移すること" do
      first_dish = dishes.first.dish
      within(find('div.popular_dish', text: first_dish.name)) do
        click_on "こちら"
      end
      expect(current_path).to eq dish_path(first_dish.id)
    end
  end
end
