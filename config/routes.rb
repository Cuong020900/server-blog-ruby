Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create]
  resources :posts
  resources :comments
  post '/login', to: 'auth#create'
  get '/user-info', to: 'users#user_info'
  get '/user-info-by-id', to: 'users#user_info_by_id'
  get '/top-trending', to: 'posts#top_trending'
  post '/posts/get-post-by-condition', to: 'posts#post_by_condition'
  get '/my-post', to: 'posts#my_post'
  post '/find-post', to: 'posts#find_post'
  post '/clip-post', to: 'posts#clip_post'
  get '/my-clips', to: 'posts#my_clips'
end
