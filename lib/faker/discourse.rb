# frozen_string_literal: true

require 'faker'

module Faker
  class Discourse < Base
    class << self

      def category
        fetch('discourse.categories')
      end

      def group
        fetch('discourse.groups')
      end
    end
  end
end
