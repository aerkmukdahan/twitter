Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get '/tweets/:id/retweet', to: 'tweets#retweet', as: 'retweet'
  get '/tweets/user/:id', to: 'tweets/user#index', as: 'tweets_user'
  get '/tweets/hash_tag/:hash_tag', to: 'tweets/hash_tag#index', as: 'tweets_hash_tag'
  get '/tweets/hash_tag', to: 'tweets/hash_tag#search', as: 'search_hash_tags'
  post '/tweets/:id/like', to: 'tweets#like', as: 'like_tweet'
  delete '/tweets/:id/unlike', to: 'tweets#unlike', as: 'unlike_tweet'
  patch '/tweets/change_theme', to: 'tweets#theme', as: 'change_theme'
  post '/tweets/user/:id/follow', to: 'tweets/user#follow', as: 'follow'
  delete '/tweets/user/:id/unfollow', to: 'tweets/user#unfollow', as: 'unfollow'
  
  resources :tweets
  root to: 'tweets#index'
end
