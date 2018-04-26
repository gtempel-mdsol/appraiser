# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem 'typhoeus',                   '~> 1.0'
gem 'json',                       '~> 2.1'
gem 'rspec',                      '~> 3.0'

group :development do
  gem 'guard-rspec', require: false
end

group :test do
  gem 'simplecov',                '~> 0.16', require: false
  gem "pry", "~> 0.11.3"
  gem "pry-byebug", "~> 3.6"
end


# Added at 2018-04-11 13:37:46 -0400 by gtempel:
gem "rubocop", "~> 0.54.0"

# Added at 2018-04-12 13:34:38 -0400 by gtempel:
gem "rubocop-rspec", "~> 1.25"
