source "http://rubygems.org"

ruby '1.9.3'

gem 'thor',     '>= 0.17'
gem 'bundler',  '>= 1.3'
gem "rails",    "~> 4.0.0.beta1", github: 'rails/rails'

# Declare your gem's dependencies in rent_messaging.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# gem 'rent_core', path: '/Users/kmandrup/private/repos/company/engines/rent_core'

gem 'mongoid',    '>= 4',     github: 'mongoid/mongoid'
gem 'sugar-high', '~> 0.7.3', github: 'kristianmandrup/sugar-high'

gem 'hashie',     '~> 1.2'
gem 'concerned',  '~> 0.1.5'

gem "rspec-rails", :group => [:test, :development]

gem 'money-mongoid', github: 'kristianmandrup/money-mongoid'

group :test do  
  # time travel
  # gem 'timecop',  '~> 0.3.5', :git => 'git://github.com/change/timecop.git'
  gem 'delorean',   '~> 1.1.1'

  gem 'cutter',     '~> 0.8.2'

  # data store
  gem 'database_cleaner',   '>= 0.8'

  # Fake data
  gem 'ffaker', '~> 1.14.1', :path => '/Users/kmandrup/private/repos/ffaker' # :git => 'git://github.com/kristianmandrup/ffaker.git'
  gem 'fakeweb'

  gem 'shoulda'         
  gem 'shoulda-matchers'

  gem 'factory_girl_rails', :require => false
  gem "capybara"
  gem "capybara-webkit"
  gem 'growl'  
  gem "spork"
  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "guard-spork"
  gem "launchy"

  # http://railsapps.github.com/tutorial-rails-mongoid-devise.html
  # gem 'mongoid-rspec', '>= 1.6.0', github: 'evansagge/mongoid-rspec'

  gem 'spork-rails', '>= 3.2.0', github: 'mcl/spork-rails'
end

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'