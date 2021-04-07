# frozen_string_literal: true

require 'i18n'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require file }

I18n.load_path += Dir[File.join(__dir__, 'faker', 'locales', '**/*.yml')]
I18n.reload! if I18n.backend.initialized?

module DiscourseDev
  require 'discourse_dev/railtie'
  require 'discourse_dev/engine'

  def self.config
    @config ||= Config.new
  end
end

require "active_record/database_configurations"

ActiveRecord::Tasks::DatabaseTasks.module_eval do
  alias_method :rails_each_current_configuration, :each_current_configuration

  private
  def each_current_configuration(environment, name = nil)
    rails_each_current_configuration(environment, name) { |db_config|
      next if environment == "development" && ENV["SKIP_TEST_DATABASE"] == "1" && db_config["database"] != "discourse_development"
      yield db_config
    }
  end
end
