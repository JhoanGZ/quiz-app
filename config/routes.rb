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

  get "up" => "rails/health#show", as: :rails_health_check

  root "quizzes#index"
end
