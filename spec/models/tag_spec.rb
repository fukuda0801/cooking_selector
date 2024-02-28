require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "tagが問題なく作成される" do
    complete_tag = build(:tag)
    expect(complete_tag).to be_valid
  end

  it "nameが未入力の場合、無効" do
    nothing_name = build(:tag, name: "")
    expect(nothing_name).not_to be_valid
  end

  it "nameがすでに存在している場合、無効" do
    create(:tag, name: "卵")
    duplicate_tag = build(:tag, name: "卵")
    expect(duplicate_tag).not_to be_valid
  end

  it "categoryが未入力の場合、無効" do
    nothing_category = build(:tag, category: "")
    expect(nothing_category).not_to be_valid
  end
end
