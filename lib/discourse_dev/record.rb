# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    attr_reader :model, :type, :count

    def initialize(model, count = DEFAULT_COUNT)
      @model = model
      @type = model.to_s
      @count = count
    end

    def create!
      record = model.create!(data)
      yield(record)
      putc "."
    end

    def populate!
      puts "Creating #{count} sample #{type.downcase} records"
      count.times { create! }
      puts
    end

    def self.populate!
      self.new.populate!
    end
  end
end
