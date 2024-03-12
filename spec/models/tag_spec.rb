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
    create(:tag, name: "わかめ")
    duplicate_tag = build(:tag, name: "わかめ")
    expect(duplicate_tag).not_to be_valid
  end

  it "categoryが未入力の場合、無効" do
    nothing_category = build(:tag, category: "")
    expect(nothing_category).not_to be_valid
  end

  it "dishと関連のあるtagを削除してもdishは削除されないこと" do
    related_dish = create(:dish)
    related_tag = create(:tag)
    create(:dish_tag, dish: related_dish, tag: related_tag)
    related_tag.destroy
    expect(Dish.exists?(related_dish.id)).to be true
  end
end
