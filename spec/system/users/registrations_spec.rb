require 'rails_helper'

RSpec.describe "Registration", type: :system do
  def extract_confirmation_url(email)
    body = email.body.encoded
    url_matches = body.match(/href="(?<url>.+?)"/)
    url_matches[:url]
  end

  describe "アカウント新規作成" do
    context "認証に問題がない場合" do
      it "アカウントの新規作成ができること" do
        visit new_user_registration_path
        fill_in "アカウント名", with: "ユーザー"
        fill_in "メールアドレス", with: "abc@abc.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        choose "男性"
        click_on "新規登録する"

        email = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(email)
        visit url

        user = User.find_by(email: "abc@abc.com")
        expect(user).not_to be_nil
        expect(user.name).to eq "ユーザー"
        expect(current_path).to eq new_user_session_path
      end
    end

    context "認証に問題がある場合" do
      it "アカウントの新規作成ができないこと" do
        visit new_user_registration_path
        fill_in "アカウント名", with: "ユーザー"
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        choose "女性"
        click_on "新規登録する"

        expect(current_path).to eq "/users"
        expect(page).to have_content "メールアドレス が入力されていません。"
      end
    end
  end

  describe "アカウント編集" do
    let!(:user) { create(:user) }

    context "編集後の情報に問題がない場合" do
      it "アカウントの編集ができること" do
        visit new_user_session_path
        fill_in "アカウント名", with: user.name
        fill_in "パスワード", with: user.password
        click_on "ログインする"

        visit user_path(user.id)
        click_on "こちら"
        expect(current_path).to eq edit_user_registration_path
        fill_in "アカウント", with: "ユーザー変更後"
        fill_in "新しいパスワード", with: "newpassword"
        fill_in "パスワード確認", with: "newpassword"
        fill_in "現在のパスワード", with: user.password
        choose "男性"
        click_on "変更を保存する"

        expect(current_path).to eq root_path
        expect(page).to have_content "アカウント情報を変更しました。"
        user.reload
        expect(user.name).to eq "ユーザー変更後"
      end
    end

    context "編集後の情報に問題がある場合" do
      it "アカウントの編集ができないこと" do
        visit new_user_session_path
        fill_in "アカウント名", with: user.name
        fill_in "パスワード", with: user.password
        click_on "ログインする"

        visit user_path(user.id)
        click_on "こちら"
        expect(current_path).to eq edit_user_registration_path
        fill_in "アカウント", with: ""
        fill_in "新しいパスワード", with: "newpassword"
        fill_in "パスワード確認", with: "newpassword"
        fill_in "現在のパスワード", with: user.password
        choose "男性"
        click_on "変更を保存する"

        expect(page).to have_content "が入力されていません。"
        expect(user.name).not_to eq ""
      end
    end

    context "ゲストユーザーの場合" do
      it "ゲストユーザーの場合、ユーザーページに編集画面へのリンクが存在しないこと" do
        visit root_path
        click_on "ゲストログイン"
        guest_user = User.find_by(email: "guest1@example.com")
        visit user_path(guest_user.id)
        expect(page).not_to have_link "user_info_link"
      end
    end
  end

  describe "アカウント削除" do
    let!(:user_delete) { create(:user) }

    it "ユーザーが退会できること" do
      visit new_user_session_path
      fill_in "アカウント名", with: user_delete.name
      fill_in "パスワード", with: user_delete.password
      click_on "ログインする"

      click_on "退会する"
      expect { user_delete.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
