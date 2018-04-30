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
  resources :comments, only: [:destroy]
  resources :collects, only: [:destroy]

  resources :users, except: :index do

    resources :comments, only: [:index, :update]
    resources :collects, only: [:index]

    member do
      get :posts
      get :drafts
    end

  end

  resources :followships, only: [:create, :destroy]

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :users
  end
end
