# frozen_string_literal: true

require 'discourse_dev/record'
require 'faker'

module DiscourseDev
  class Post < Record

    attr_reader :topic

    def initialize(topic, count = DEFAULT_COUNT)
      super(::Post, count)
      @topic = topic

      category = topic.category
      unless category.groups.blank?
        group_ids = category.groups.pluck(:id)
        @user_ids = ::GroupUser.where(group_id: group_ids).pluck(:user_id)
        @user_count = @user_ids.count
      end
    end

    def data
      {
        topic_id: topic.id,
        raw: Faker::Markdown.sandwich(sentences: 5),
        skip_validations: true
      }
    end

    def create!
      PostCreator.new(user, data).create!
    end

    def user
      return User.random if topic.category.groups.blank?
      return Discourse.system_user if @user_ids.blank?
      
      position = Faker::Number.between(from: 0, to: @user_count - 1)
      ::User.find(@user_ids[position])
    end

    def populate!
      @count.times do |i|
        @index = i
        create!
      end
    end
  end
end
