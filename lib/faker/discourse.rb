# frozen_string_literal: true

module Faker
  class Discourse < Base
    class << self

      def category
        fetch('discourse.categories')
      end
    end
  end
end
