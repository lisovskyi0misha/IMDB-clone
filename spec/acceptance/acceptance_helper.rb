require 'rails_helper'

RSpec.configure do |config|
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new app, browser: :chrome,
      options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
  end

  Capybara.javascript_driver = :chrome

  config.use_transactional_fixtures = false

  config.include Warden::Test::Helpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    Warden.test_mode!
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end
