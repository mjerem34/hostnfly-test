# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
FactoryBot.use_parent_strategy = false
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Capybara::RSpecMatchers, type: :helper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActionView::Helpers::NumberHelper


  config.before :all do
    DatabaseCleaner.clean_with :truncation, except: %w[ar_internal_metadata]
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end

  config.before(:each, type: :with_custom_pg_sequences) do
    ActiveRecord::Base.connection.execute('CREATE SEQUENCE client_receipts_id_seq')
    ActiveRecord::Base.connection.execute('CREATE SEQUENCE owner_receipts_id_seq')
  end
  config.after(:each, type: :with_custom_pg_sequences) do
    ActiveRecord::Base.connection.execute('DROP SEQUENCE client_receipts_id_seq')
    ActiveRecord::Base.connection.execute('DROP SEQUENCE owner_receipts_id_seq')
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
RSpec::Support::ObjectFormatter
  .default_instance
  .max_formatted_output_length = ENV['RSPEC_MAX_FORMATTED_OUTPUT_LENGTH'].to_i || 200
