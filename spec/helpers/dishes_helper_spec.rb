require 'rails_helper'

RSpec.describe DishesHelper, type: :helper do
  describe '#tag_category_select' do
    let!(:tag_category) { create(:tag, category: '野菜', name: 'にんじん') }
    let!(:params) { { search: { tags: { '野菜' => 'にんじん' } } } }
    before do
      allow(helper).to receive(:params).and_return(params)
    end

    it "指定されたタグカテゴリーに対するセレクトタグを返すこと" do
      expect(helper.tag_category_select(tag_category)).to include "にんじん"
      expect(helper.tag_category_select(tag_category)).to include "search[tags][野菜]"
    end

    it "送られてきたパラメーターに基づいて正しいオプションが選択されていること" do
      expect(helper.tag_category_select(tag_category)).to include 'selected="selected"'
    end
  end
end
