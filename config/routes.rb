Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  post 'game_1', to: 'application#game_1'
  post 'game_2', to: 'application#game_2'
  post 'game_3', to: 'application#game_3'
  post 'game_4', to: 'application#game_4'
  get 'me', to: 'application#me'
  get 'sharing', to: 'application#sharing'
  get 'total_users', to: 'application#total_users'
  get 'top_gamers', to: 'application#top_gamers'
  get 'current_rank', to: 'application#current_rank'

  root to: "application#home"
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
