# frozen_string_literal: true

require 'discourse_dev'
require 'rails'

module DiscourseDev
  class Railtie < Rails::Railtie
    railtie_name :discourse_dev

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
