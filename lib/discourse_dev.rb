# frozen_string_literal: true

require 'i18n'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require file }

I18n.load_path += Dir[File.join(__dir__, 'faker', 'locales', '**/*.yml')]
I18n.reload! if I18n.backend.initialized?

module DiscourseDev
  require 'discourse_dev/railtie'
  require 'discourse_dev/engine'
end
