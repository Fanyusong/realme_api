Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  post 'update_game_score', to: 'application#update_game_score'

  get 'me', to: 'application#me'
  get 'count_user', to: 'application#count_user'
  get 'quay_so', to: 'application#quay_so'
  get 'change_coin_to_live', to: 'application#change_coin_to_live'
  get 'sharing', to: 'application#sharing'

  root to: "application#home"
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
