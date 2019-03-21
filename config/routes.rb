Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  post 'update_game_score', to: 'application#update_game_score'
  post 'receive_email', to: 'application#receive_email'
  get 'profile', to: 'application#profile'
  get 'number_of_users', to: 'application#number_of_users'

  root to: "application#home"
  match '*unmatched', to: 'application#route_not_found', via: :all
end
