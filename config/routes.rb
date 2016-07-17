Rails.application.routes.draw do
  root to: "date_selects#new"

  namespace :admin do
    resources :events
    root to: "events#index"
  end

  resources :events, only: [:index]
  resources :composers, only: [:index, :show]
  resources :hyperlinks, only: [:index]

  get 'pages/home'
  get 'pages/about'
  get 'pages/contact'
  get 'pages/resources'

  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'

  resources :date_selects, only: [:new, :create]
  resources :resources, only: [:index]
end
