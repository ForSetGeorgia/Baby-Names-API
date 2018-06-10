Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    concern :api_base do
      resources :years, only: [:index]
      resources :names, only: [:index, :show] do
        collection do
          get 'search'
          get 'most_popular_for_year'
          get 'most_popular_for_year_and_gender'
        end
      end
    end

    namespace :v1 do
      concerns :api_base
    end

  end
end
