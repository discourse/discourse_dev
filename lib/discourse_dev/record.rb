# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    attr_reader :model, :type

    def initialize(model, count = DEFAULT_COUNT)
      Faker::Config.random = Random.new(1)
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

      @total_count = model.count
      puts
    end

    def index
      @index
    end

    def random
      @total_count ||= model.count
      offset = Faker::Number.between(from: 0, to: @total_count - 1)
      model.offset(offset).first
    end

    def self.populate!
      self.new.populate!
    end
  end
end
