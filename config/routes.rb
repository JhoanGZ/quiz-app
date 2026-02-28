Rails.application.routes.draw do

  devise_for :users

  resources :quizzes do
    member do
      patch :publish
    end
    resources :questions, except: [:index] do
      resources :options, only: [:create, :destroy]
    end
  end

  resources :attempts, only: [:create, :show]
  
  # API V1
  namespace :api do
    namespace :v1 do
      resources :quizzes, only: [:index, :show]
      resources :attempts, only: [:create, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "quizzes#index"
end
