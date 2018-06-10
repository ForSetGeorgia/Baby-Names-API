Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    concern :api_base do
      resources :names, only: [:index, :show] do
        collection do
          get 'years'
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
