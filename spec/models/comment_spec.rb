require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "commentが問題なく作成される" do
    complete_comment = build(:comment)
    expect(complete_comment).to be_valid
  end

  it "contentが未入力の場合無効" do
    no_content_comment = build(:comment, content: "")
    expect(no_content_comment).not_to be_valid
  end

  it "contentが50文字を超える場合無効" do
    over_comment = build(:comment, content: "あ" * 51)
    expect(over_comment).not_to be_valid
  end
end
