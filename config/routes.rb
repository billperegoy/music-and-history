Rails.application.routes.draw do
  namespace :admin do
    resources :events
    root to: "events#index"
  end

  resources :events, only: [:index]
  resources :composers, only: [:index, :show]
  root to: "pages#home"

  get 'pages/home'
  get 'pages/about'
  get 'pages/contact'
  get 'pages/links'
  get 'pages/resources'
end
