Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  post 'new_post', to: 'application#new_post'
  put 'update_live', to: 'application#update_live'
  put 'sharing', to: 'application#sharing'
  put 'identify', to: 'application#identify'
  put 'update_game_score', to: 'application#update_game'
  post 'report', to: 'application#error_report'

  get 'me', to: 'application#me'
  get 'posts', to: 'application#posts'
  get 'all_posts', to: 'application#all_posts'
  get 'count_user', to: 'application#count_user'

  root to: "application#home"
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
