require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Jiaoyu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.

    #2. skip rspec test and js/css generated
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.orm :active_record
      #g.assets false #this is both for stylesheets and javascripts
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.rspec false
    end

    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local   #active_record对数据库交互的时区设置
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :zh

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
        html_tag.html_safe
    }
  end
end

Dir[File.join(Rails.root, "lib", "*.rb")].each do |file|
  require file
end
