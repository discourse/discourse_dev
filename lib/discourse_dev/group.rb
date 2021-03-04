# frozen_string_literal: true

require 'discourse_dev/record'
require 'rails'
require 'faker'

module DiscourseDev
  class Group < Record

    DEFAULT_COUNT = 15.freeze

    def initialize(count = DEFAULT_COUNT)
      super(::Group, count)
      @existing_names = ::Group.where(automatic: false).pluck(:name)
    end

    def data
      name = Faker::Discourse.group

      while @existing_names.include? name
        name = Faker::Company.profession
      end

      @existing_names << name

      {
        name: name
      }
    end
  end
end
