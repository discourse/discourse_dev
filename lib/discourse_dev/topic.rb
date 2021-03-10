# frozen_string_literal: true

require 'discourse_dev/record'
require 'faker'

module DiscourseDev
  class Topic < Record

    def initialize(count = DEFAULT_COUNT)
      super(::Topic, count)
      @category_ids = ::Category.pluck(:id)
      @user_count = ::User.count
    end

    def data
      {
        title: title[0, SiteSetting.max_topic_title_length],
        raw: Faker::Markdown.sandwich(sentences: 5),
        category: @category_ids.sample,
        tags: tags,
        topic_opts: { custom_fields: { dev_sample: true } },
        skip_validations: true
      }
    end

    def title
      if index <= I18n.t("faker.discourse.topics").count
        Faker::Discourse.unique.topic
      else
        Faker::Lorem.unique.sentence(word_count: 3, supplemental: true, random_words_to_add: 4).chomp(".")
      end
    end

    def tags
      @tags = []

      Faker::Number.between(from: 0, to: 3).times do
        @tags << Faker::Discourse.tag
      end

      @tags.uniq
    end

    def create!
      offset = rand(@user_count)
      user = ::User.offset(offset).first

      PostCreator.new(user, data).create!
      putc "."
    end
  end
end
