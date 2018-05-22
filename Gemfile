source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails'

gem 'activerecord-import'
gem 'coffee-rails'
gem 'datagrid'
gem 'foreman'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg'
gem 'puma'
gem 'redis-rails'
gem 'sass-rails'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sinatra', require: false
gem 'slim'
gem 'turbolinks'
gem 'uglifier'

group :development do
  gem 'memory_profiler'
  gem 'rack-mini-profiler', require: false
  gem 'stackprof'

  # gem 'better_errors'
  # gem 'binding_of_caller'
  gem 'listen'
  gem 'pronto'
  gem 'pronto-flay', require: false
  gem 'pronto-rails_best_practices', require: false
  gem 'pronto-rubocop', require: false
  gem 'pry-rails'
  gem 'rubocop', require: false
  # gem 'rubycritic'
  gem 'spring'
  gem 'spring-watcher-listen'

  # gem 'bullet'
  # gem 'dotenv-rails'
  # gem 'letter_opener'
  # gem 'rails-erd'
end
