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
      @max_likes_count = DiscourseDev.config.max_likes_count
      unless category.groups.blank?
        group_ids = category.groups.pluck(:id)
        @user_ids = ::GroupUser.where(group_id: group_ids).pluck(:user_id)
        @user_count = @user_ids.count
        @max_likes_count = @user_count - 1
      end
    end

    def data
      {
        topic_id: topic.id,
        raw: Faker::Markdown.sandwich(sentences: 5),
        created_at: Faker::Time.between(from: topic.last_posted_at, to: DateTime.now),
        skip_validations: true
      }
    end

    def create!
      post = PostCreator.new(user, data).create!
      topic.reload
      generate_likes(post)
    end

    def generate_likes(post)
      user_ids = [post.user_id]

      Faker::Number.between(from: 0, to: @max_likes_count).times do
        user = self.user
        next if user_ids.include?(user.id)

        PostActionCreator.new(user, post, PostActionType.types[:like]).perform
        user_ids << user.id
      end
    end

    def user
      return User.random if topic.category.groups.blank?
      return Discourse.system_user if @user_ids.blank?
      
      position = Faker::Number.between(from: 0, to: @user_count - 1)
      ::User.find(@user_ids[position])
    end

    def populate!
      generate_likes(topic.first_post)

      @count.times do |i|
        @index = i
        create!
      end
    end
  end
end
