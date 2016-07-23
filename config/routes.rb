Rails.application.routes.draw do
  root to: "date_selects#new"

  resources :events, only: [:index]
  resources :composers, only: [:index, :show]
  resources :hyperlinks, only: [:index]

  get 'pages/about'

  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'

  resources :date_selects, only: [:new, :create]
  resources :resources, only: [:index]
end
