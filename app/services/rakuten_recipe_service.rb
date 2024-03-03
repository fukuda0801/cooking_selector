class RakutenRecipeService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426'

  def initialize(app_id)
    @app_id = app_id
  end

  def fetch_recipes(category_id)
    self.class.get('', query: { applicationId: @app_id, categoryId: category_id })
  end
end
