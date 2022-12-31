Rails.application.routes.draw do
  get 'posts/index', to: 'posts#index'
  get 'posts/create', to: 'posts#create'
  get 'posts/edit', to: 'posts#edit'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/users', to: 'users#index'
  post '/users/login', to: 'users#login'
  post '/users/create', to: 'users#create'
  # Defines the root path route ("/")
  # root "articles#index"
end
