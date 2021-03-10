# frozen_string_literal: true

require 'discourse_dev/record'
require 'rails'
require 'faker'

module DiscourseDev
  class Category < Record

    def initialize(count = DEFAULT_COUNT)
      super(::Category, count)
      @existing_names = ::Category.pluck(:name)
      @parent_category_ids = ::Category.where(parent_category_id: nil).pluck(:id)
      @group_count = ::Group.count
    end

    def data
      name = Faker::Discourse.category
      parent_category_id = nil

      while @existing_names.include? name
        name = Faker::Discourse.category
      end

      @existing_names << name

      if Faker::Boolean.boolean(true_ratio: 0.6)
        parent_category_id = @parent_category_ids.sample
        @permissions = ::Category.find(parent_category_id).permissions_params.presence
      else
        @permissions = nil
      end

      {
        name: name,
        description: Faker::Lorem.paragraph,
        user_id: ::Discourse::SYSTEM_USER_ID,
        color: Faker::Color.hex_color.last(6),
        parent_category_id: parent_category_id
      }
    end

    def permissions
      return @permissions if @permissions.present?
      return { everyone: :full } if Faker::Boolean.boolean(true_ratio: 0.75)
        
      permission = {}
      group = Group.random
      permission[group.id] = Faker::Number.between(from: 1, to: 3)

      permission
    end

    def create!
      super do |category|
        category.set_permissions(permissions)
        category.save!

        @parent_category_ids << category.id if category.parent_category_id.blank?
      end
    end
  end
end
