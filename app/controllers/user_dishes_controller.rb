class UserDishesController < ApplicationController
  before_action :authenticate_user!

  def create
    @dish = Dish.find(params[:dish_id])
    if current_user.dishes.count < 12
      current_user.dishes << @dish unless current_user.dishes.include?(@dish)
      redirect_to dish_path(@dish.id), notice: 'お気に入りに追加しました'
    else
      redirect_to dish_path(@dish.id), alert: 'お気に入りは最大12件までです'
    end
  end

  def destroy
    @user_dish = current_user.user_dishes.find_by(dish_id: params[:id])
    if @user_dish&.destroy
      redirect_to dish_path(@user_dish.dish_id), notice: 'お気に入りから削除しました'
    else
      redirect_to dishes_path, alert: '削除に失敗しました'
    end
  end
end
