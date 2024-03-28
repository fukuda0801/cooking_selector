Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'homes#index'
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users, only: [:show, :destroy] do
    member do
      get :favorites
      get :comments
    end
  end
  resources :user_dishes, only: [:create, :destroy]
  resources :dishes do
    collection do
      get 'search'
      get 'random'
      get 'condition'
      get 'popular'
      get 'keyword'
    end
    resources :comments, only: [:create, :destroy]
  end
end
