Rails.application.routes.draw do

  root 'static_pages#home'

  get 'sessions/new'

  get 'users/new'

  post '/users/:id', to: 'users#cashTransfer'

  get '/help', to: 'static_pages#help'
  
  get '/about', to: 'static_pages#about'
#When we 'GET' the signup page, we use users#new
  get '/signup', to: 'users#new'
#When we 'POST' to the signup page (i.e. create new user)
#we use 'users#create'
  post '/signup', to: 'users#create'

  post '/portfolios/new', to: 'portfolios#create'

  post '/portfolios/:id', to: 'portfolios#add_execution'

  post '/securitys/:id', to: 'securitys#add_execution'

  get '/executes/index', to: 'executes#execution'

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
