ActiveAdmin.register Comment, as: "ReviewComment" do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :content, :user_id, :dish_id
  # permit_params :content, :user_id, :dish_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:content, :user_id, :dish_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :content
    column :user_id
    column :dish_id
    actions
  end

  filter :content
  filter :user_id
  filter :dish_id

  form do |f|
    f.inputs do
      f.input :content
      f.input :user_id, as: :select, collection: User.all
      f.input :dish_id, as: :select, collection: Dish.all
    end
    f.actions
  end

  show do
    attributes_table do
      row :content
      row :user_id
      row :dish_id
    end
  end
end
