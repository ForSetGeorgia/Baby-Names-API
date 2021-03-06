source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
gem 'pg', '~> 1.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# auto restart puma workers to keep memory usage low
gem 'puma_worker_killer', '~> 0.1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'dotenv-rails', '~> 2.1', '>= 2.1.1' # env variables
gem 'friendly_id', '~> 5.2', '>= 5.2.4' # url slugs
gem 'stringex', '~> 2.8', '>= 2.8.4' # convert ka to latin for slugs
gem 'active_model_serializers', '~> 0.10.7' # serialize api calls
gem 'will_paginate', '~> 3.1', '>= 3.1.5' # pagination

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Server-related tasks (such as deploy)
  gem 'mina', '~> 0.3.8', require: false

  # Mina for multiple servers
  gem 'mina-multistage', '~> 1.0.2', require: false

end

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end
