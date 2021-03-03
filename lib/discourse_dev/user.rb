# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

module DiscourseDev
  class User < Record

    def initialize
      super(::User)
    end

    def create!
      name = Faker::Name.name
      email = Faker::Internet.email(name: name)
      username = Faker::Internet.username(specifier: name)
      username_lower = username.downcase

      ::User.create!(
        name: name,
        email: email,
        username: username,
        username_lower: username_lower,
        trust_level: Faker::Number.between(from: 1, to: 4)
      )

      super
    end
  end
end
