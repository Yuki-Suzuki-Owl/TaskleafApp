Rails.application.routes.draw do
  # root "sessions#new"
  root "tasks#index"
  get "/login"    ,to:"sessions#new"
  post "/login"   ,to:"sessions#create"
  delete "/logout",to:"sessions#destroy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :group_tasks
  resources :tasks
  namespace :admin do
    resources :users
    resources :groups
  end
end
