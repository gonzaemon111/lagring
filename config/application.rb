require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lagring
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_record.default_timezone = :local
    config.time_zone = 'Asia/Tokyo'

    # NOTE: i18n
    config.i18n.default_locale = :ja
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = %i[ja en zh ko fr]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '**', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '**', '**', '*.{rb,yml}').to_s]

    config.action_controller.include_all_helpers = false
    config.filter_parameters << :password
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: true,
                       helper_specs: true,
                       routing_specs: true,
                       model_specs: true,
                       controller_specs: false,
                       request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.helper false
      g.assets false
      # g.template_engine = :slim
    end

    config.generators.system_tests = nil
    config.beginning_of_week = :sunday
  end
end
