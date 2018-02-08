Rails.application.routes.draw do

  namespace :api do
    resources :portfolios, :securitys, :users
  end

  root 'static_pages#home'

  get 'sessions/new'

  get 'users/new'

  post '/users/:id', to: 'users#cashTransfer'

  get '/help', to: 'static_pages#help'
  
  get '/about', to: 'static_pages#about'
#When we 'GET' the signup page, we use users#new
  get '/signup', to: 'users#new'

  get '/useragreement', to: 'static_pages#user_agreement'

#When we 'POST' to the signup page (i.e. create new user)
#we use 'users#create'
  post '/signup', to: 'users#create'

  post '/portfolios/new', to: 'portfolios#create'
  get '/portfolios/new', to: 'portfolios#new'

  get '/portfolios/:id', to: 'portfolios#show'

  post '/securitys/:id', to: 'securitys#add_execution'

  get '/executes/index', to: 'executes#index'

  get '/securitys/index', to: 'securitys#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :account_activation, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :portfolios
  resources :securitys
  resources :executes
end
