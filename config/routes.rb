Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'liked_tracks', to: 'spotify#liked_tracks'
  get 'liked_albums', to: 'spotify#liked_albums'
end
