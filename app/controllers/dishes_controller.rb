class DishesController < ApplicationController
  def show
    @dish = Dish.find(params[:id])
    rakuten_service = RakutenRecipeService.new('1073376705435074167')
    @recipes = rakuten_service.fetch_recipes(@dish.category_full_id)
  end

  def random
    @dish = Dish.includes(:tags).random
    rakuten_service = RakutenRecipeService.new('1073376705435074167')
    @recipes = rakuten_service.fetch_recipes(@dish.category_full_id)
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
