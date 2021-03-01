# frozen_string_literal: true

def check_environment!
  if ENV["RAILS_ENV"] != "development"
    raise "DB dev commands are only supported in development"
  end
end

desc 'Populate sample content for development environment'
task 'db:dev:populate' => ['db:load_config'] do |_, args|
  check_environment!
end

desc 'Run db:migrate:reset task and populate sample content for development environment'
task 'db:dev:reset' => ['db:load_config'] do |_, args|
  check_environment!

  Rake::Task['db:migrate:reset'].invoke
  Rake::Task['admin:create'].invoke
  Rake::Task['db:dev:populate'].invoke
end
