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
      @index = nil
    end

    def create!
      record = model.create!(data)
      yield(record) if block_given?
    end

    def populate!
      puts "Creating #{@count} sample #{type.downcase} records"

      @count.times do |i|
        @index = i
        create!
        putc "."
      end

      puts
    end

    def index
      @index
    end

    def self.populate!
      self.new.populate!
    end

    def self.random(model)
      offset = Faker::Number.between(from: 0, to: model.count - 1)
      model.offset(offset).first
    end
  end
end
