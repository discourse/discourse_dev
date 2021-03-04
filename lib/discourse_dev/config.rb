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
  end
end
