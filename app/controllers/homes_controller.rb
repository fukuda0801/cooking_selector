class HomesController < ApplicationController
  def index
    @q = Dish.ransack(params[:q])
  end
end
