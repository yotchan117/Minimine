Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in" => "users/sessions#guest_sign_in"
  end
  root to: "homes#top"

  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get :quit
      get :favorites
    end
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", ad: "followers"
  end

  get "search" => "searches#search"
  get "result" => "searches#result"

  resources :notifications, only: [:index, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
