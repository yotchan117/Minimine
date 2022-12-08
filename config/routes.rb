Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"

  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  # get "users/:id/quit" => "users#quit", as: "quit"
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get :quit
      get :favorites
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
