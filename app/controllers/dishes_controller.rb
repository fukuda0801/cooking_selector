class DishesController < ApplicationController
  before_action :set_rakuten_service, only: [:show, :random]

  def show
    @dish = Dish.with_attached_image.find(params[:id])
    @comment = Comment.new
    @comments = @dish.comments.order(created_at: :desc).includes(:user).page(params[:page]).per(5)
    @recipes = @rakuten_service.fetch_recipes(@dish.category_full_id)
  end

  def random
    @dish = Dish.includes(:tags).random
    redirect_to dish_path(@dish)
  end

  def keyword
    @dishes = Dish.reference(params[:keyword]).page(params[:page])
    @reference_word = params[:keyword]
  end

  def search
    @q = Dish.ransack(params[:q])
    @results = @q.result(distinct: true).with_attached_image.page(params[:page])
    @genre_selected = params.dig(:q, :genre_eq)
  end

  def condition
    @selected_tag_names = params.dig(:search, :tags).values.compact_blank
    @dishes = Dish.search_by_tag_names(@selected_tag_names).with_attached_image.page(params[:page])
  end

  def popular
    @popular_dishes = Dish.popular(10)
  end

  private

  def set_rakuten_service
    app_id = ENV.fetch('RAKUTEN_APP_ID')
    @rakuten_service = RakutenRecipeService.new(app_id)
  end
end
