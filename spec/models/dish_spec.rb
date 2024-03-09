require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe "Dishモデル" do
    context "バリデーション" do
      it "dishが問題なく作成される" do
        complete_dish = build(:dish)
        expect(complete_dish).to be_valid
      end

      it "nameが未入力の場合無効" do
        nothing_name_dish = build(:dish, name: "")
        expect(nothing_name_dish).not_to be_valid
      end

      it "nameがすでに存在している場合" do
        create(:dish, name: "味噌汁")
        duplicate_dish = build(:dish, name: "味噌汁")
        expect(duplicate_dish).not_to be_valid
      end

      it "descriptionが未入力の場合無効" do
        nothing_description_dish = build(:dish, description: "")
        expect(nothing_description_dish).not_to be_valid
      end

      it "descriptionが25文字を超えると無効" do
        over_description_dish = build(:dish, description: "a" * 26)
        expect(over_description_dish).not_to be_valid
      end

      it "cook_timeが未入力の場合" do
        nothing_cooktime_dish = build(:dish, cook_time: "")
        expect(nothing_cooktime_dish).not_to be_valid
      end

      it "calorieが未入力の場合" do
        nothing_calorie_dish = build(:dish, calorie: "")
        expect(nothing_calorie_dish).not_to be_valid
      end

      it "difficultyが未入力の場合" do
        nothing_difficulty_dish = build(:dish, difficulty: "")
        expect(nothing_difficulty_dish).not_to be_valid
      end

      it "genreが未入力の場合" do
        nothing_genre_dish = build(:dish, genre: "")
        expect(nothing_genre_dish).not_to be_valid
      end

      it "tagと関連のあるdishを削除してもtagは削除されないこと" do
        related_dish = create(:dish)
        related_tag = create(:tag)
        create(:dish_tag, dish: related_dish, tag: related_tag)
        related_dish.destroy
        expect(Tag.exists?(related_tag.id)).to be true
      end
    end

    context "self.randomメソッド" do
      it "dishオブジェクトを返すか" do
        dish1 = create(:dish)
        dish2 = create(:dish)
        expect(Dish.random).to eq(dish1).or eq(dish2)
      end
    end

    context "self.search_by_tag_names" do
      let!(:tag1) { create(:tag, name: "わかめ") }
      let!(:tag2) { create(:tag, name: "豆腐") }
      let!(:dish_with_tag1) { create(:dish) }
      let!(:dish_with_tag2) { create(:dish) }

      before do
        create(:dish_tag, dish: dish_with_tag1, tag: tag1)
        create(:dish_tag, dish: dish_with_tag2, tag: tag2)
      end

      it "選んだtagを持つ料理を取得できるか" do
        result = Dish.search_by_tag_names(["わかめ"])
        expect(result).to include(dish_with_tag1)
        expect(result).not_to include(dish_with_tag2)
      end

      it "tagを選ばなかった場合、すべての料理を取得できるか" do
        expect(Dish.search_by_tag_names([])).to match_array([dish_with_tag1, dish_with_tag2])
      end
    end
  end
end
