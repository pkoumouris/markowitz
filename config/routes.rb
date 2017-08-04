Rails.application.routes.draw do

  root 'static_pages#home'

  get 'sessions/new'

  get 'users/new'

  get '/help', to: 'static_pages#help'
  
  get '/about', to: 'static_pages#about'
#When we 'GET' the signup page, we use users#new
  get '/signup', to: 'users#new'
#When we 'POST' to the signup page (i.e. create new user)
#we use 'users#create'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
end
