ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :sex, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :password, :password_confirmation
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :sex, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    column :sex
    actions
  end

  filter :email
  filter :name
  filter :sex

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :sex
    end
    f.actions
  end
end
