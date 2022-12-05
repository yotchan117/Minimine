Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"

  resources :posts
  get "users/:id/confirm" => "users#confirm"
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
