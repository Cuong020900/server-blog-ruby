Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create]
  resources :posts
  resources :comments
  post '/login', to: 'auth#create'
  get '/user-info', to: 'users#user_info'
  get '/top-trending', to: 'posts#top_trending'
  get '/my-post', to: 'posts#my_post'
end
