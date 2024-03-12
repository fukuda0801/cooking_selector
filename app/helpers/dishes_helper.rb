module DishesHelper
  def tag_category_select(tag_category)
    condition_label = label_tag "search[tags][#{tag_category.category}]", tag_category.category, class: "home_condition_tag"
    condition_select = select_tag "search[tags][#{tag_category.category}]",
                                  options_from_collection_for_select(
                                    Tag.where(category: tag_category.category),
                                    :name, :name, selected: params.dig(:search, :tags, tag_category.category)
                                  ),
                                  include_blank: "未選択", class: "home_condition_form"
    safe_join([condition_label, condition_select])
  end
end
