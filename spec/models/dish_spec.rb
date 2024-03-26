require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe "Dishモデル" do
    context "バリデーション" do
      it "dishが問題なく作成されること" do
        complete_dish = build(:dish)
        expect(complete_dish).to be_valid
      end

      it "nameが未入力の場合無効" do
        nothing_name_dish = build(:dish, name: "")
        expect(nothing_name_dish).not_to be_valid
      end

      it "nameがすでに存在している場合無効" do
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

      it "cook_timeが未入力の場合無効" do
        nothing_cooktime_dish = build(:dish, cook_time: "")
        expect(nothing_cooktime_dish).not_to be_valid
      end

      it "calorieが未入力の場合無効" do
        nothing_calorie_dish = build(:dish, calorie: "")
        expect(nothing_calorie_dish).not_to be_valid
      end

      it "difficultyが未入力の場合無効" do
        nothing_difficulty_dish = build(:dish, difficulty: "")
        expect(nothing_difficulty_dish).not_to be_valid
      end

      it "genreが未入力の場合無効" do
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
  end

  describe "self.randomメソッド" do
    it "dishオブジェクトを返すこと" do
      dish1 = create(:dish)
      dish2 = create(:dish)
      expect(Dish.random).to eq(dish1).or eq(dish2)
    end
  end

  describe "self.search_by_tag_names" do
    let!(:tag1) { create(:tag, name: "わかめ") }
    let!(:tag2) { create(:tag, name: "豆腐") }
    let!(:dish_with_tag1) { create(:dish) }
    let!(:dish_with_tag2) { create(:dish) }

    before do
      create(:dish_tag, dish: dish_with_tag1, tag: tag1)
      create(:dish_tag, dish: dish_with_tag2, tag: tag2)
    end

    it "選んだtagを持つ料理を取得できること" do
      result = Dish.search_by_tag_names(["わかめ"])
      expect(result).to include(dish_with_tag1)
      expect(result).not_to include(dish_with_tag2)
    end

    it "tagを選ばなかった場合、すべての料理を取得できること" do
      expect(Dish.search_by_tag_names([])).to match_array([dish_with_tag1, dish_with_tag2])
    end
  end

  describe ".favorites_count" do
    let!(:user) { create(:user) }
    let!(:dish) { create(:dish) }
    let!(:user_dish) { create(:user_dish, user: user, dish: dish) }

    it "お気に入り登録数を取得できること" do
      expect(dish.favorites_count).to eq 1
    end
  end

  describe ".popularity_rank" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:dish_rank1) { create(:dish) }
    let!(:dish_rank3) { create(:dish) }
    let!(:dish_rank2) { create(:dish) }
    let!(:dish_rank4) { create(:dish) }
    let!(:user1_dish1) { create(:user_dish, user: user1, dish: dish_rank1) }
    let!(:user2_dish1) { create(:user_dish, user: user2, dish: dish_rank1) }
    let!(:user1_dish2) { create(:user_dish, user: user1, dish: dish_rank2) }
    let!(:user1_dish3) { create(:user_dish, user: user1, dish: dish_rank3) }

    context ".popularity_rank" do
      it "人気順位が正しく取得できること" do
        expect(dish_rank1.popularity_rank).to eq 1
        expect(dish_rank2.popularity_rank).to eq 2
        expect(dish_rank3.popularity_rank).to eq 3
        expect(dish_rank4.popularity_rank).to eq 4
      end
    end

    context "self.popular" do
      it "指定した料理数、ランキングが取得されること" do
        expect(Dish.popular(3)).to include(dish_rank1, dish_rank2, dish_rank3)
      end
    end
  end

  describe "self.reference" do
    let!(:popular_dish1) { create(:dish, name: "中華丼") }
    let!(:popular_dish2) { create(:dish, name: "ペペロンチーノ") }
    let!(:popular_tag) { create(:tag, name: "卵") }
    let!(:popular_dish_tag) { create(:dish_tag, dish: popular_dish1, tag: popular_tag) }

    context "存在する料理名を部分一致検索した場合" do
      it "検索ワードを含む料理を取得できること" do
        expect(Dish.reference("中華")).to include popular_dish1
        expect(Dish.reference("ロン")).not_to include popular_dish1
      end
    end

    context "存在する材料名を部分一致検索した場合" do
      it "検索ワードを含む材料を持つ料理を取得できること" do
        expect(Dish.reference("卵")).to include popular_dish1
        expect(Dish.reference("卵")).not_to include popular_dish2
      end
    end

    context "未入力で検索を行った場合" do
      it "全ての料理が取得できること" do
        expect(Dish.reference("")).to include(popular_dish1, popular_dish2)
      end
    end
  end
end
