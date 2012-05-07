source :rubygems

gem 'rack'
gem 'rake'
gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-synchrony', :require => 'sinatra/synchrony'
gem 'faraday'
gem 'json'
gem 'rest-client'
gem 'google_places'
gem 'geokit'
gem 'foursquare2'
gem 'flickraw'
require 'yaml'
gem 'slim'
gem 'thin'
# gem 'grape'

group :development do
  gem 'pry'
  gem 'logger'
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
  gem 'thin'
end

group :production do
end

group :test do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
  gem 'capybara', :require => "capybara/rspec"
  gem 'simplecov', :require => false
end