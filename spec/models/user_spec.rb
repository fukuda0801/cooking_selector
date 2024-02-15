require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Userモデルのバリデーション" do
    it "userが問題なく作成される" do
      complete_user = build(:user)
      expect(complete_user).to be_valid
    end

    it "nameが未入力の場合は無効" do
      nothing_name_user = build(:user, name: "")
      expect(nothing_name_user).not_to be_valid
      expect(nothing_name_user.errors[:name]).to include "が入力されていません。"
    end

    it "nameが20文字を超える場合は無効" do
      long_user = build(:user, name: "a" * 21)
      expect(long_user).not_to be_valid
      expect(long_user.errors[:name]).to include "は20文字以内に設定してくだい。"
    end

    it "emailが既に存在する場合無効" do
      user = create(:user)
      duplicate_email_user = build(:user, email: user.email)
      expect(duplicate_email_user).not_to be_valid
      expect(duplicate_email_user.errors[:email]).to include "は既に使用されています。"
    end

    it "パスワードが半角英数字でない場合無効" do
      wrong_password_user = build(:user, password: "あいうえおか", password_confirmation: "あいうえおか")
      expect(wrong_password_user).not_to be_valid
      expect(wrong_password_user.errors[:password]).to include "は半角英数字で入力してください。"
    end

    it "sexが未入力の場合無効" do
      nothing_sex_user = build(:user, sex: "")
      expect(nothing_sex_user).not_to be_valid
      expect(nothing_sex_user.errors[:sex]).to include "が入力されていません。"
    end
  end

  describe "self.guest" do
    context "ゲストユーザーが存在しない場合" do
      it "新しいゲストユーザーを作成する" do
        expect { User.guest }.to change(User, :count).by(1)
        guest_user = User.guest
        expect(guest_user.email).to eq 'guest1@example.com'
        expect(guest_user.name).to eq "ゲストユーザー"
        expect(guest_user.sex).to eq "未設定(ゲスト用)"
        expect(guest_user).to be_confirmed
      end
    end

    context "ゲストユーザーが既に存在する場合" do
      before do
        User.guest
      end

      it "新しいユーザーを作成せず、既存のゲストユーザーを返す" do
        expect { User.guest }.not_to change(User, :count)
        guest_user = User.guest
        expect(guest_user.email).to eq 'guest1@example.com'
      end
    end
  end
end
