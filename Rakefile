# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.


require File.expand_path('../config/application', __FILE__)
Pak::Application.load_tasks
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end
 
desc 'Default: run tests'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
end
