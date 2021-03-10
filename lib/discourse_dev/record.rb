# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    attr_reader :model, :type, :count

    def initialize(model, count = DEFAULT_COUNT)
      Faker::Config.random = Random.new(1)
      @model = model
      @type = model.to_s
      @count = count
      @index = nil
    end

    def create!
      record = model.create!(data)
      yield(record)
      putc "."
    end

    def populate!
      puts "Creating #{count} sample #{type.downcase} records"
      count.times do |i|
        @index = i
        create!
      end
      puts
    end

    def self.populate!
      self.new.populate!
    end

    def index
      @index
    end
  end
end
