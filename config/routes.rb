Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'
  resources :posts do

    resources :comments, only: [:create]

    collection do
      get :feeds
    end

  end

  resources :categories, only: :show
  
  resources :comments, only: [:edit, :update, :destroy] do
    member do
      get :cancel
    end
  end

  resources :collects, only: [:create, :destroy]

  resources :users, except: :index do

    resources :comments, only: [:index, :update]
    resources :collects, only: [:index]

    member do
      get :posts
      get :drafts
    end

  end

  resources :friendships, only: [:create, :destroy] do
    member do
      post :cancel
      post :accept
      delete :ignore
      get :check
    end
  end

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :users
  end
end
