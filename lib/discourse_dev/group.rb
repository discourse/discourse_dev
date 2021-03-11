# frozen_string_literal: true

require 'discourse_dev/record'
require 'rails'
require 'faker'

module DiscourseDev
  class Group < Record

    DEFAULT_COUNT = 15.freeze

    def initialize(count = DEFAULT_COUNT)
      super(::Group, count)
    end

    def data
      {
        name: Faker::Discourse.unique.group,
        public_exit: Faker::Boolean.boolean,
        public_admission: Faker::Boolean.boolean,
        primary_group: Faker::Boolean.boolean
      }
    end

    def create!
      super do |group|
        if Faker::Boolean.boolean
          group.add_owner(::Discourse.system_user)
          group.allow_membership_requests = true
          group.save!
        end
      end
    end

    def self.random
      super(::Group)
    end
  end
end
