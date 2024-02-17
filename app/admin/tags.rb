ActiveAdmin.register Tag do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :category, dish_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :category]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :category
    actions
  end

  filter :name
  filter :category

  form do |f|
    f.inputs do
      f.input :name
      f.input :category
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :category
    end
  end
end
