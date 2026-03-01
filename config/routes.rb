Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :creators, only: [:index, :show] do
    resources :contents, only: [:new, :create, :edit, :update]
  end
end
