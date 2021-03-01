# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/discourse_dev/**/*.rb'].each {|file| require file }

module DiscourseDev
  require 'discourse_dev/railtie' if defined?(Rails)
end
