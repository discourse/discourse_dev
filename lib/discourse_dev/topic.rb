# frozen_string_literal: true

require 'discourse_dev/record'
require 'faker'

module DiscourseDev
  class Topic < Record

    def initialize(count = DEFAULT_COUNT)
      super(::Topic, count)
    end

    def data
      {
        title: title[0, SiteSetting.max_topic_title_length],
        raw: Faker::Markdown.sandwich(sentences: 5),
        category: @category.id,
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
      @category = Category.random
      topic = data
      post = PostCreator.new(user, topic).create!

      if topic[:title] == "Coolest thing you have seen today"
        reply_count = 99
      else
        reply_count = Faker::Number.between(from: 0, to: 12)
      end

      Post.new(post.topic, reply_count).populate!
    end

    def user
      return User.random if @category.groups.blank?

      group_ids = @category.groups.pluck(:id)
      user_ids = ::GroupUser.where(group_id: group_ids).pluck(:user_id)
      user_count = user_ids.count
      position = Faker::Number.between(from: 0, to: user_count - 1)
      ::User.find(user_ids[position] || Discourse::SYSTEM_USER_ID)
    end

    def current_count
      category_definition_topic_ids = ::Category.pluck(:topic_id)
      ::Topic.where(archetype: :regular).where.not(id: category_definition_topic_ids).count
    end
  end
end
