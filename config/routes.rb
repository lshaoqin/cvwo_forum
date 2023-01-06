Rails.application.routes.draw do
  get 'comments/fetch', to: 'comments#fetch'
  post 'comments/new', to: 'comments#new'
  post 'comments/edit', to: 'comments#edit'
  post 'comments/delete', to: 'comments#delete'

  get 'posts/index', to: 'posts#index'
  post 'posts/create', to: 'posts#create'
  post 'posts/edit', to: 'posts#edit'
  get 'posts/count', to: 'posts#count'
  get 'posts/get_by_id', to: 'posts#get_by_id'
 
  get '/users', to: 'users#index'
  post '/users/login', to: 'users#login'
  post '/users/create', to: 'users#create'

  post '/tags/new', to: 'tags#new'
  post '/tags/revoke', to: 'tags#revoke'
   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
