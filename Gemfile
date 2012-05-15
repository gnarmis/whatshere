source :rubygems

gem 'rack'
gem 'rake'
gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-synchrony', :require => 'sinatra/synchrony'
gem 'faraday'
gem 'rest-client'
gem 'google_places'
gem 'geokit'
gem 'foursquare2'
gem 'flickraw'
gem 'slim'
gem 'thin'
# gem 'grape'

require 'yaml'
require 'json'

group :development do
  gem 'pry', :require => "pry"
  gem 'logger'
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
  gem 'thin'
  gem 'foreman'
end

group :production do
end

group :test do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
  gem 'capybara', :require => "capybara/rspec"
  gem 'simplecov', :require => false
end