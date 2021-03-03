# frozen_string_literal: true

require 'discourse_dev'
require 'rails'
require 'faker'

class DiscourseDev::User

  def self.create!
    name = Faker::Name.name
    username = Faker::Internet.username(specifier: name)
    username_lower: username.downcase
    ::User.create!(
      name: name,
      username: username,
      username_lower: username_lower,
      trust_level: Faker::Number.between(from: 1, to: 4)
    )
  end

  def self.populate!
    30.times { create! }
  end
end
