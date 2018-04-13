Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'
  resources :posts do

    resources :comments, only: [:index, :create, :delete]

    collection do
      get :feeds
    end

  end

  resources :categories, only: :show

  resources :users do

    member do
      get :posts
      get :comments
      get :collects
    end

  end

  resources :followships, only: [:create, :destroy]

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :users
  end
end
