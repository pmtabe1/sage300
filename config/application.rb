require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sage300
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # Use ruotes for error handling
    config.exceptions_app = self.routes

    # PDFKit
    # config.middleware.use "PDFKit::Middleware", :print_media_type => true

    # Encodes BigDecimal objects as a decimals
    # ActiveSupport.encode_big_decimal_as_string = false

    # Setting default time zone as Eastern Time
    #config.time_zone = 'Eastern Time (US & Canada)'
    #config.active_record.default_timezone = :local
    
    # Rack Attack
    config.middleware.use Rack::Attack
  end
end
