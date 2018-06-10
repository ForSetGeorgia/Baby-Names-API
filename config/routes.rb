Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    get 'v1/name/:id', to: 'v1#name', defaults: { format: 'json' }
    namespace :v1 do
      get 'years', defaults: { format: 'json' }
      get 'search', defaults: { format: 'json' }
      get 'most_popular_for_year', defaults: { format: 'json' }
      get 'most_popular_for_year_and_gender', defaults: { format: 'json' }
      get 'least_popular_for_year', defaults: { format: 'json' }
      get 'least_popular_for_year_and_gender', defaults: { format: 'json' }
    end

  end
end
