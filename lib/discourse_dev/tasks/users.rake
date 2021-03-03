# frozen_string_literal: true

desc 'Populate sample content for development environment'
task 'users:populate' => ['db:load_config'] do |_, args|
  DiscourseDev::User.populate!
end
