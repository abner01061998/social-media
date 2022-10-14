Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'friend_portfolio/:id', to: 'users#friends_portfolio', as: 'friend_portfolio'
  get 'my_friends', to: 'friendships#index'
  get 'search_stock', to: 'stocks#search_stock'
  get 'search_friend', to: 'friendships#search_friend'
  get 'friend_profile/:user', to: 'users#show', as: 'friend_profile'
end
