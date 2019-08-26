require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Systempicks
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Register the local development ENV file to the YML file in config
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    # Open up Rack::Cors to the world (for now)
    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:8080, http://system-picks-api.herokuapp.com'
        resource '*',
          headers: :any,
          credentials: true,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
  end
end
