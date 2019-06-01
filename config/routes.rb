Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'register', to: 'application#register'
  post 'sign_in', to: 'application#sign_in'
  put 'update_live', to: 'application#update_live'
  get 'me', to: 'application#me'

  root to: "application#home"
  match '*unmatched', to: 'application#route_not_found', via: :all
end
