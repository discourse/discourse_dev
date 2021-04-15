# frozen_string_literal: true

require 'rails'
require 'highline/import'

module DiscourseDev
  class Config
    attr_reader :config, :default_config, :file_path

    def initialize
      default_file_path = File.join(DiscourseDev.root, "config", "dev.yml")
      @file_path = File.join(Rails.root, "config", "dev.yml")
      @default_config = YAML.load_file(default_file_path)

      if File.exists?(file_path)
        @config = YAML.load_file(file_path)
      else
        puts "I did no detect a custom `config/dev.yml` file, creating one for you where you can amend defaults."
        FileUtils.cp(default_file_path, file_path)
        @config = {}
      end
    end

    def update!
      update_site_settings
      create_admin_user
      create_new_user
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
        create_admin_user_from_settings(settings)
      else
        create_admin_user_from_input
      end
    end

    def create_new_user
      settings = config["new_user"]

      if settings.present?
        email = settings["email"] || "new_user@example.com"

        new_user = ::User.create!(
          email: email,
          username: settings["username"] || UserNameSuggester.suggest(email)
        )
        new_user.email_tokens.update_all confirmed: true
        new_user.activate
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
      return config[name] if config.keys.include?(name)
      default_config[name]
    end

    def create_admin_user_from_settings(settings)
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
    end

    def create_admin_user_from_input
      begin
        email = ask("Email:  ")
        password = ask("Password (optional, press ENTER to skip):  ")
        username = UserNameSuggester.suggest(email)

        admin = ::User.new(
          email: email,
          username: username
        )

        if password.present?
          admin.password = password
        else
          puts "Once site is running use https://localhost:9292/user/#{username}/become to access the account in development"
        end

        admin.name = ask("Full name:  ") if SiteSetting.full_name_required
        saved = admin.save

        if saved
          File.open(file_path, 'a') do | file|
            file.puts("admin:")
            file.puts("  username: #{admin.username}")
            file.puts("  email: #{admin.email}")
            file.puts("  password: #{password}") if password.present?
          end
        else
          say(admin.errors.full_messages.join("\n"))
        end
      end while !saved

      admin.active = true
      admin.save

      admin.grant_admin!
      if admin.trust_level < 1
        admin.change_trust_level!(1)
      end
      admin.email_tokens.update_all confirmed: true
      admin.activate

      say("\nAdmin account created successfully with username #{admin.username}")
    end
  end
end
