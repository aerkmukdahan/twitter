Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tweets
  get '/tweets/:id/retweet', to: 'tweets#retweet', as: 'retweet'
  root 'tweets#index'
end
