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
  Rake::Task['dev:config'].invoke
  Rake::Task['dev:populate'].invoke
end

desc 'Initialize development environment'
task 'dev:config' => ['db:load_config'] do |_, args|
  DiscourseDev::Config.new.update!
end

desc 'Populate sample content for development environment'
task 'dev:populate' => ['db:load_config'] do |_, args|
  Rake::Task['groups:populate'].invoke
  Rake::Task['users:populate'].invoke
  Rake::Task['categories:populate'].invoke
  Rake::Task['tags:populate'].invoke
  Rake::Task['topics:populate'].invoke
end

desc 'Repopulate sample datas in development environment'
task 'dev:repopulate' => ['db:load_config'] do |_, args|
  require 'highline/import'

  answer = ask("Do you want to repopulate the database with fresh data? It will recreate DBs and run migration from scratch before generating all the samples. (Y/n)  ")

  if (answer == "" || answer.downcase == 'y')
    Rake::Task['dev:reset'].invoke
  else
    puts "You can run `dev:reset` rake task to do this repopulate action anytime."
  end
end
