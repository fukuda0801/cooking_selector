require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let!(:dish) { create(:dish) }
  let!(:user_dish) { create(:user_dish, user: user, dish: dish) }

  describe 'GET /users/sign_up' do
    before do
      get new_user_registration_path
    end

    it "新規登録ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - 新規アカウント登録となること" do
      expect(response.body).to include "<title>Cooking Selector - 新規アカウント登録</title>"
    end
  end

  describe 'GET /users/sign_up' do
    before do
      get new_user_session_path
    end

    it "ログインページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルが Cooking Selector - ログインとなること" do
      expect(response.body).to include "<title>Cooking Selector - ログイン</title>"
    end
  end

  describe 'GET /users/edit' do
    before do
      sign_in user
      get edit_user_registration_path
    end

    it "アカウント編集ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking Selector - アカウント編集" do
      expect(response.body).to include "<title>Cooking Selector - アカウント編集</title>"
    end
  end

  describe 'GET /users/:id' do
    before do
      sign_in user
      get user_path(user.id)
    end

    it "アカウント情報ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking selector - ユーザー情報となること" do
      expect(response.body).to include "<title>Cooking Selector - ユーザー情報</title>"
    end
  end

  describe 'GET /users/:id/favorites' do
    before do
      sign_in user
      get favorites_user_path(user.id)
    end

    it "お気に入り料理ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking selector - お気に入り料理" do
      expect(response.body).to include "<title>Cooking Selector - お気に入り料理</title>"
    end
  end

  describe 'GET /users/:id/comments' do
    before do
      sign_in user
      get comments_user_path(user.id)
    end

    it "お気に入り料理ページが200のレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルがCooking selector - お気に入り料理" do
      expect(response.body).to include "<title>Cooking Selector - コメント一覧</title>"
    end
  end
end
