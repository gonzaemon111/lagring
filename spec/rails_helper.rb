require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'faker'
require 'shoulda/matchers'
require 'database_cleaner'
require 'yaml'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include ActiveJob::TestHelper
  config.include ViewComponent::TestHelpers, type: :component

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_active_record = true

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    ::Rails.application.load_tasks
    # DatabaseCleaner.clean_with(:truncation, { except: YAML.load_file('config/excludes_tenant_model.yml')['excludes'].map(&:underscore).map(&:pluralize) })
  end

  # unless ENV.fetch('CI_ENV', 0).to_i.zero?
  #   config.before(:suite) do
  #     SeedFu.seed
  #   end
  # end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
    # NOTE: publicなテナントに戻る
    # Apartment::Tenant.reset
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
