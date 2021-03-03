# frozen_string_literal: true

require 'discourse_dev/record'
require 'faker'

module DiscourseDev
  class Topic < Record

    def initialize(count = DEFAULT_COUNT)
      super(::Topic, count)
      @category_ids = ::Category.pluck(:id)
      @user_count = User.count
    end

    def data
      {
        title: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4)[0, SiteSetting.max_topic_title_length],
        raw: Faker::Markdown.sandwich,
        category_id: @category_ids.sample,
        topic_opts: { custom_fields: { dev_sample: true } },
        skip_validations: true
      }
    end

    def create!
      offset = rand(@user_count)
      user = ::User.offset(offset).first

      PostCreator.new(user, data).create!
      putc "."
    end
  end
end
