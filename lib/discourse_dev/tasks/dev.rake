# frozen_string_literal: true

def check_environment!
  if !Rails.env.development?
    raise "Database commands are only supported in development environment"
  end
end

desc 'Run db:migrate:reset task and populate sample content for development environment'
task 'dev:reset' => ['db:load_config'] do |_, args|
  check_environment!

  Rake::Task['db:migrate:reset'].invoke
  Rake::Task['admin:create'].invoke
  Rake::Task['dev:populate'].invoke
end

desc 'Populate sample content for development environment'
task 'dev:populate' => ['db:load_config'] do |_, args|
  Rake::Task['groups:populate'].invoke
  Rake::Task['users:populate'].invoke
  Rake::Task['categories:populate'].invoke
  Rake::Task['topics:populate'].invoke
end
