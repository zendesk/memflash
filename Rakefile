require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

desc "Bundle all gemfiles"
task :bundle_all, [:bundler_args] do |task, args|
  Bundler.with_original_env do
    sh "BUNDLE_GEMFILE=Gemfile matching_bundle #{args[:bundler_args]}"
    Dir["gemfiles/*.gemfile"].each do |gemfile|
      sh "BUNDLE_GEMFILE=#{gemfile} matching_bundle #{args[:bundler_args]}"
    end
  end
end

namespace :test do
  desc "Run tests with all gemfiles"
  task :all do
    Bundler.with_original_env do
      Dir["gemfiles/*.gemfile"].each do |gemfile|
        sh "BUNDLE_GEMFILE=#{gemfile} rake test"
      end
    end
  end
end
