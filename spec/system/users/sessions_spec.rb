require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  describe "アカウントログイン" do
    context "認証に問題がない場合" do
      it "ログインできること、ログアウトできること" do
        visit new_user_session_path
        fill_in 'アカウント名', with: user.name
        fill_in 'パスワード', with: user.password
        click_on 'ログインする'
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログインしました。'
      end
    end

    context "認証に問題がある場合" do
      it "ログインできないこと" do
        visit new_user_session_path
        fill_in 'アカウント名', with: user.name
        fill_in 'パスワード', with: ''
        click_on 'ログインする'
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'アカウント名またはパスワードが違います。'
      end
    end
  end

  describe "アカウントログアウト" do
    it "ユーザーがログアウトできること" do
      visit new_user_session_path
      fill_in 'アカウント名', with: user.name
      fill_in 'パスワード', with: user.password
      click_on 'ログインする'
      expect(current_path).to eq root_path

      visit root_path
      click_on 'ログアウト'
      expect(page).to have_content('ログアウトしました。')
      expect(page).to have_content('ログイン')
    end
  end

  describe "ゲストログイン" do
    it "ゲストログインできること" do
      visit root_path
      click_on "ゲストログイン"
      expect(page).to have_content "ゲストユーザーとしてログインしました。"
      expect(current_path).to eq root_path
    end
  end
end
