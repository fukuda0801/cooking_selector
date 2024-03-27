class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.dish = Dish.find(params[:dish_id])
    if @comment.save
      redirect_to dish_path(@comment.dish.id), notice: 'コメントが追加されました。'
    else
      redirect_to dish_path(@comment.dish.id), alert: 'コメントの追加に失敗しました。'
    end
  end

  def destroy
    @dish = Dish.find(params[:dish_id])
    @comment = Comment.find_by(id: params[:id], dish_id: params[:dish_id])
    if @comment.destroy
      redirect_to dish_path(@dish.id), notice: 'コメントを削除しました。'
    else
      redirect_to dish_path(@dish.id), alert: 'コメントの削除に失敗しました。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
