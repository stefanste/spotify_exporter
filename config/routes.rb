Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'liked_tracks', to: 'spotify#liked_tracks'
  get 'liked_albums', to: 'spotify#liked_albums'

  # Defines the root path route ("/")
  # root "articles#index"
end
