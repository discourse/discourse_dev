# frozen_string_literal: true

require 'discourse_dev/record'
require 'rails'
require 'faker'

module DiscourseDev
  class Tag < Record

    def initialize(count = DEFAULT_COUNT)
      super(::Tag, count)
    end

    def data
      {
        name: Faker::Discourse.unique.tag,
      }
    end
  end
end
