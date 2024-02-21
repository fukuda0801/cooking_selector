class DishesController < ApplicationController
  def show
    @dish = Dish.find(params[:id])
  end

  def random
    @dish = Dish.includes(:tags).random
  end

  def search
    @q = Dish.ransack(params[:q])
    @results = @q.result(distinct: true).page(params[:page])
    @genre_selected = params.dig(:q, :genre_eq)
  end

  def condition
    @selected_tag_names = params.dig(:search, :tags).values.reject(&:blank?)
    @dishes = Dish.search_by_tag_names(@selected_tag_names).page(params[:page])
  end
end
