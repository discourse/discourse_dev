# frozen_string_literal: true

require 'rails'

module DiscourseDev
  class Config
    attr_reader :config, :default_config

    def initialize
      @default_config = YAML.load_file(File.join(File.expand_path(__dir__), "config.yml"))
      file_path = File.join(Rails.root, "config", "dev.yml")

      if File.exists?(file_path)
        @config = YAML.load_file(file_path)
      else
        @config = {}
      end
    end

    def update!
      update_site_settings
      create_admin_user
      set_seed
    end

    def update_site_settings
      puts "Updating site settings..."

      site_settings = config["site_settings"] || {}

      site_settings.each do |key, value|
        puts "#{key} = #{value}"
        SiteSetting.set(key, value)
      end

      keys = site_settings.keys

      default_config["site_settings"].each do |key, value|
        next if keys.include?(key)

        puts "#{key} = #{value}"
        SiteSetting.set(key, value)
      end

      SiteSetting.refresh!
    end

    def create_admin_user
      puts "Creating default admin user account..."

      settings = config["admin"]

      if settings.present?
        email = settings["email"]

        admin = ::User.create!(
          email: email,
          username: settings["username"] || UserNameSuggester.suggest(email),
          password: settings["password"]
        )
        admin.grant_admin!
        if admin.trust_level < 1
          admin.change_trust_level!(1)
        end
        admin.email_tokens.update_all confirmed: true
        admin.activate
      else
        Rake::Task['admin:create'].invoke
      end
    end

    def set_seed
      seed = self.seed || 1
      Faker::Config.random = Random.new(seed)
    end

    def start_date
      DateTime.parse(config["start_date"] || default_config["start_date"])
    end

    def method_missing(name)
      name = name.to_s
      config[name] || default_config[name]
    end
  end
end
