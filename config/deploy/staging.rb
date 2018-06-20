set :domain, 'beta.forset.ge'
set :user, 'deploy'
set :application, 'BabyNames'
# easier to use https; if you use ssh then you have to create key on server
set :repository, 'https://github.com/ForSetGeorgia/Baby-Names-API.git'
set :branch, 'deploy'
set :web_url, ENV['STAGING_WEB_URL']
set :visible_to_robots, false
set :use_ssl, false
