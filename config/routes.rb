Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    namespace :v1 do
      get 'name', defaults: { format: 'json' }
      get 'search', defaults: { format: 'json' }

      get 'years', defaults: { format: 'json' }

      get 'most_popular_for_year', defaults: { format: 'json' }
      get 'most_popular_for_year_and_gender', defaults: { format: 'json' }
      get 'least_popular_for_year', defaults: { format: 'json' }
      get 'least_popular_for_year_and_gender', defaults: { format: 'json' }

      get 'largest_amount_increase_for_year', defaults: { format: 'json' }
      get 'largest_amount_increase_for_year_and_gender', defaults: { format: 'json' }
      get 'largest_amount_decrease_for_year', defaults: { format: 'json' }
      get 'largest_amount_decrease_for_year_and_gender', defaults: { format: 'json' }


      get 'years_amount_summary', defaults: { format: 'json' }
      get 'years_unique_names_summary', defaults: { format: 'json' }
    end

  end
end
