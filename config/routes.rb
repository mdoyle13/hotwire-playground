Rails.application.routes.draw do
  root to: 'pages#index'
  
  resources :todos do
    collection do
      get :complete, :incomplete
    end
    member do
      post :toggle
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
