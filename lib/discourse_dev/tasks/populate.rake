# frozen_string_literal: true

desc 'Creates sample user accounts'
task 'users:populate' => ['db:load_config'] do |_, args|
  DiscourseDev::User.populate!
end

desc 'Creates sample topics'
task 'topics:populate' => ['db:load_config'] do |_, args|
  DiscourseDev::Topic.populate!
end
