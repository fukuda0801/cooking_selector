ActiveAdmin.register Dish do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :cook_time, :calorie, :difficulty, :category_full_id, :genre, :image, tag_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :cook_time, :calorie]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :cook_time
    column :calorie
    column :difficulty
    column :genre
    column :category_full_id
    column "Tags" do |dish|
      dish.tags.map(&:name).join(", ")
    end
    column :image do |dish|
      image_tag(dish.image.variant(resize_to_fill: [100, 100]).processed) if dish.image.attached?
    end
    actions
  end

  filter :name
  filter :description
  filter :cook_time
  filter :calorie

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :cook_time
      f.input :calorie
      f.input :difficulty
      f.input :genre
      f.input :tags, as: :check_boxes
      f.input :category_full_id
      f.input :image, :as => :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :cook_time
      row :calorie
      row :difficulty
      row :genre
      row :category_full_id
      row :image do
        image_tag url_for(dish.image.variant(resize_to_limit: [200, 200]).processed) if dish.image.attached?
      end
      row :tags do |dish|
        dish.tags.map(&:name).join(", ")
      end
    end
  end
end
