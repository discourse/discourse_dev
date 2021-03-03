# frozen_string_literal: true

module Faker
  class Discourse < Base
    class << self

      def category
        fetch('artist.names')
      end
    end
  end
end
