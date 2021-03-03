# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    def initialize(model)
      @type = model.to_s
    end

    def create!
      putc "."
    end

    def populate!
      puts "Creating #{count} sample #{@type.downcase}s"
      count.times { create! }
    end

    def count
      @count || DEFAULT_COUNT
    end
  end
end
