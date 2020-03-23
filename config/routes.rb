Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  post 'game_1', to: 'application#game_1'
  post 'game_2', to: 'application#game_2'
  post 'game_3', to: 'application#game_3'
  post 'game_4', to: 'application#game_4'
  post 'game_5', to: 'application#game_5'
  post 'buy_ticket', to: 'application#buy_ticket'
  get 'me', to: 'application#me'
  get 'count_user', to: 'application#count_user'
  get 'change_coin_to_live', to: 'application#change_coin_to_live'
  get 'sharing', to: 'application#sharing'

  root to: "application#home"
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
