require 'rails_helper'

RSpec.describe "comments", type: :system do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:dish) { create(:dish) }
  let!(:comment) { create(:comment, dish: dish, user: user) }
  let!(:another_comment) { create(:comment, dish: dish, user: another_user, content: "素晴らしい") }

  describe "ユーザーコメント一覧" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "ユーザーコメント情報が表示されること" do
        visit comments_user_path(user.id)
        expect(page).to have_content comment.created_at.to_s(:custom_date)
        expect(page).to have_content comment.content
      end

      it "料理名クリックで料理詳細ページへ遷移すること" do
        visit comments_user_path(user.id)
        click_on comment.dish.name
        expect(current_path).to eq dish_path(comment.dish.id)
      end

      it "他のユーザーのコメントが表示されないこと" do
        visit comments_user_path(user.id)
        expect(page).not_to have_content another_comment.content
      end

      it "コメントを削除できること" do
        visit comments_user_path(user.id)
        click_on "削除"
        expect(page).not_to have_content comment.content
      end

      it "他のユーザーのidを使用してコメント一覧ページにアクセスしても、ログインユーザーのコメントが表示されること" do
        visit comments_user_path(another_user.id)
        expect(page).to have_content comment.content
      end
    end

    context "ログインしていない場合" do
      it "ログインユーザーのidを使用してコメント一覧ページにアクセスできないこと" do
        visit comments_user_path(user.id)
        expect(current_path).to eq new_user_session_path
      end

      it "コメント一覧ページへのリンクが表示されないこと" do
        visit root_path
        expect(page).not_to have_content "コメント一覧"
      end
    end
  end
end
