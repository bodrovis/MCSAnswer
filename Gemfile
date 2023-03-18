# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'pg', '~> 1.0'
gem 'rails', '~> 7.0.3'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

gem 'redis', '~> 5'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'rails-i18n', '~> 7'

gem 'bcrypt', '~> 3.1.7'

gem 'pundit', '~> 2.1'

gem 'activerecord-import', '~> 1.4'
gem 'acts_as_list', '~> 1.0'
gem 'after_commit_everywhere', '~> 1'
gem 'pagy', '~> 6'
gem 'pg_search', '~> 2'
gem 'rack-attack', '~> 6.6'
gem 'rack-brotli', '~> 1.2'
gem 'recaptcha', '~> 5.10'
gem 'sidekiq', '~> 7'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

gem 'newrelic_rpm'

group :production do
  gem 'dalli', '~> 3'
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  gem 'brakeman', '~> 5'
  gem 'bullet', '~> 7'
  gem 'rubocop', '~> 1.18', require: false
  gem 'rubocop-i18n', '~> 3', require: false
  gem 'rubocop-performance', '~> 1.11', require: false
  gem 'rubocop-rails', '~> 2.11', require: false
end
