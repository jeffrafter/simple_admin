ENV["RAILS_ENV"] = 'test'

require File.expand_path("../sample/config/environment.rb", __FILE__)
require "rails/test_help"
require "rspec/rails"
require "factory_girl"
require "mocha"
require "shoulda"

Rails.backtrace_cleaner.remove_silencers!

require 'capybara/rails'
Capybara.default_driver = :rack_test

# We are going to need some stubs
require File.expand_path("../factories.rb", __FILE__)

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../sample/db/migrate/", __FILE__)

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :mocha
end

