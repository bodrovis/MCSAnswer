# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"
require 'rack/brotli'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module McsAnswer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.available_locales = %i[ru]
    config.i18n.default_locale = :ru

    config.time_zone = 'Riga'

    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater,
                                   include: Rack::Mime::MIME_TYPES.select { |_k, v|
                                              v =~ /text|json|javascript/
                                            }.values.uniq

    config.middleware.insert_after ActionDispatch::Static, Rack::Brotli,
                                   include: Rack::Mime::MIME_TYPES.select { |_k, v|
                                              v =~ /text|json|javascript/
                                            }.values.uniq,
                                   deflater: {
                                     quality: 1
                                   }
  end
end
