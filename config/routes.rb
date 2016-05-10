Rails.application.routes.draw do
  namespace :admin do
    resources :events
    root to: "events#index"
  end

  resources :events, only: [:index]
  root to: "events#index"

  get 'pages/about'
  get 'pages/composers'
  get 'pages/contact'
  get 'pages/links'
  get 'pages/resources'
end
