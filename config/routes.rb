Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :movies, except: :index, constraints: { id: /\d.+/ } do
    get 'categories', to: 'categories#index', as: :all_categories, on: :collection
    get 'categories/:categories', to: 'categories#index', as: :categories, on: :collection
    resources :ratings, only: %i[create update destroy]
  end

  root "movies#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
