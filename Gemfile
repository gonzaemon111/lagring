source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'dotenv-rails'
gem 'enumerize'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jwt'
gem 'kredis'
gem 'pg'
gem 'puma', '~> 6.0'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 7.0.6'
gem 'redis', '~> 4.0'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

group :development, :test do
  gem 'annotate'
  gem 'better_errors'
  gem 'bullet'
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'prettier'
  gem 'pry-rails'
  gem 'reek'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'shoulda-matchers'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :test do
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'webdrivers'
end

group :production do
  gem 'logtail-rails'
end
