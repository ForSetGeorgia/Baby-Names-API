set :domain, 'alpha.forset.ge'
set :user, 'deploy'
set :application, 'BabyNames'
# easier to use https; if you use ssh then you have to create key on server
set :repository, 'https://github.com/ForSetGeorgia/Baby-Names-API.git'
set :branch, 'master'
set :web_url, ENV['PRODUCTION_WEB_URL']
set :web_url_secondary, ENV['PRODUCTION_WEB_URL_SECONDARY']
set :use_ssl, false
set :puma_worker_count, '1'
set :puma_thread_count_min, '1'
set :puma_thread_count_max, '16'
