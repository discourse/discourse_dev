# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class Record
    DEFAULT_COUNT = 30.freeze

    attr_reader :model, :type

    def initialize(model, count = DEFAULT_COUNT)
      Faker::Discourse.unique.clear
      RateLimiter.disable

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
      if current_count >= @count
        puts "Already have #{@count}+ #{type.downcase} records."

        Rake.application.top_level_tasks.each do |task_name|
          Rake::Task[task_name].reenable
        end

        Rake::Task['dev:repopulate'].invoke
        return
      end

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

    def current_count
      model.count
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
