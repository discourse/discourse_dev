# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    attr_reader :model, :type

    def initialize(model, count = DEFAULT_COUNT)
      @model = model
      @type = model.to_s
      @count = count
    end

    def create!
      model.create!(data)
      putc "."
    end

    def populate!
      puts "Creating #{count} sample #{type.downcase}s"
      count.times { create! }
    end

    def count
      @count || DEFAULT_COUNT
    end

    def self.populate!
      self.new.populate!
    end
  end
end
