Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :movies, only: %i[index show] do
    get 'categories/(:categories)', to: 'categories#index', as: :categories, on: :collection
    resources :ratings, only: %i[new edit create update destroy]
  end

  namespace :admin do
    resources :movies
  end

  root "movies#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
