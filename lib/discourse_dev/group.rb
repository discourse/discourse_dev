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
        name = Faker::Company.profession.gsub(" ", "-")
      end

      @existing_names << name

      {
        name: name,
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
  end
end
