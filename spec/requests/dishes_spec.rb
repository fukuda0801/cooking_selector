require 'rails_helper'

RSpec.describe 'Dishes', type: :request do
  let!(:dish) { create(:dish, name: "親子丼", genre: "和食") }
  let!(:tag) { create(:tag, name: "卵", category: "卵") }
  let!(:dish_tag) { create(:dish_tag, dish: dish, tag: tag) }

  describe 'GET /dishes/:id' do
    before do
      get dish_path(dish.id)
    end

    it "料理詳細ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - 料理名となること" do
      expect(response.body).to include "<title>Cooking Selector - 親子丼</title>"
    end
  end

  describe 'GET /condition' do
    before do
      get condition_dishes_path, params: { search: { tags: { "卵" => "卵" } } }
    end

    it "材料検索結果ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - 材料検索結果となること" do
      expect(response.body).to include "<title>Cooking Selector - 材料検索結果</title>"
    end
  end

  describe 'GET /search' do
    before do
      get search_dishes_path, params: { q: { genre_eq: "和食" } }
    end

    it "ジャンル検索ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - ジャンル検索結果となること" do
      expect(response.body).to include "<title>Cooking Selector - ジャンル検索結果</title>"
    end
  end

  describe 'GET/keyword' do
    before do
      get keyword_dishes_path, params: { keyword: "親子丼" }
    end

    it "キーワード検索結果ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - キーワード検索結果となること" do
      expect(response.body).to include "<title>Cooking Selector - キーワード検索結果</title>"
    end
  end

  describe 'GET/popular' do
    before do
      get popular_dishes_path
    end

    it "ランキングページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - ランキングトップ10となること" do
      expect(response.body).to include "<title>Cooking Selector - ランキングトップ10</title>"
    end
  end
end
