# frozen_string_literal: true

require 'discourse_dev/record'
require 'rails'
require 'faker'

module DiscourseDev
  class User < Record

    def initialize(count = DEFAULT_COUNT)
      super(::User, count)
    end

    def data
      name = Faker::Name.name
      email = Faker::Internet.email(name: name)
      username = Faker::Internet.username(specifier: name)[0, SiteSetting.max_username_length]
      username_lower = username.downcase

      {
        name: name,
        email: email,
        username: username,
        username_lower: username_lower,
        trust_level: Faker::Number.between(from: 1, to: 4)
      }
    end
  end
end
