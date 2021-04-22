# frozen_string_literal: true

require 'i18n'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }

module DiscourseDev
  require 'discourse_dev/railtie'
  require 'discourse_dev/engine'

  def self.auth_plugin_enabled?
    config.auth_plugin_enabled
  end

  def self.config
    @config ||= Config.new
  end

  def self.auth_plugin
    return unless auth_plugin_enabled?

    @auth_plugin ||= begin
      path = File.join(root, 'auth', 'plugin.rb')
      source = File.read(path)
      metadata = Plugin::Metadata.parse(source)
      Plugin::Instance.new(metadata, path)
    end
  end

  def self.settings_file
    File.join(root, "config", "settings.yml")
  end

  def self.client_locale_files(locale_str)
    Dir[File.join(root, "config", "locales", "client*.#{locale_str}.yml")]
  end

  def self.root
    File.expand_path("..", __dir__)
  end
end

require "active_record/database_configurations"

ActiveRecord::Tasks::DatabaseTasks.module_eval do
  alias_method :rails_each_current_configuration, :each_current_configuration

  private
  def each_current_configuration(environment, name = nil)
    rails_each_current_configuration(environment, name) { |db_config|
      next if environment == "development" &&
        ENV["SKIP_TEST_DATABASE"] == "1" &&
        db_config.configuration_hash[:database] != "discourse_development"

      yield db_config
    }
  end
end
