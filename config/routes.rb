Rails.application.routes.draw do
  resources :todos do
    member do
      post :toggle
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
