Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:index]
  post '/users/block', to: 'users#block_users'
  post '/users/unblock', to: 'users#unblock_users'
  post '/users/delete', to: 'users#delete_users'
  get '/users/name_users', to: 'users#name_users'
  delete '/users/logout', to: 'sessions#destroy'
  get "up" => "rails/health#show", as: :rails_health_check


end
