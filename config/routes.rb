Rails.application.routes.draw do
  root to: 'pages#index'
  
  resources :todos do
    member do
      post :toggle
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
