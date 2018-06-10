Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    resources :years, only: [:index]
    resources :names, only: [:index, :show] do
      collection do
        get 'search'
      end
    end

  end
end
