Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :years, only: [:index]
  resources :names, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
end
