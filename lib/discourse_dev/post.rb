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
      begin
        PostCreator.new(user, data).create!
      rescue ActiveRecord::RecordNotSaved => e
        puts e
      end
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

    def self.add_replies!(args)
      if !args[:topic_id]
        puts "Topic ID is required. Aborting."
        return
      end

      if !::Topic.find_by_id(args[:topic_id])
        puts "Topic ID does not match topic in DB, aborting."
        return
      end

      topic = ::Topic.find_by_id(args[:topic_id])
      count = args[:count] ? args[:count].to_i : 50

      puts "Creating #{count} replies in '#{topic.title}'"

      count.times do |i|
        @index = i
        begin
          reply = {
            topic_id: topic.id,
            raw: Faker::Markdown.sandwich(sentences: 5),
            skip_validations: true
          }
          PostCreator.new(User.random, reply).create!
        rescue ActiveRecord::RecordNotSaved => e
          puts e
        end
      end

      puts "Done!"
    end

  end
end
