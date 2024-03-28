class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    if User.find(params[:id]) == current_user
      @user = current_user
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def destroy
    if current_user.destroy
      redirect_to root_path, notice: 'アカウントが正常に削除されました。'
    else
      redirect_to root_path, alert: 'アカウントの削除に失敗しました。'
    end
  end

  def favorites
    @favorite_dishes = current_user.dishes
  end

  def comments
    @user = current_user
    @comments = @user.comments.order(created_at: :desc).includes(:dish).page(params[:page]).per(10)
  end
end
