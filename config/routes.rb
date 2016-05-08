Rails.application.routes.draw do
  namespace :admin do
    resources :events
    root to: "events#index"
  end

  resources :events, only: [:index]
  root to: "events#index"
end
