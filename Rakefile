require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

desc "Bundle all gemfiles"
task :bundle_all do
  Bundler.with_original_env do
    system("which -s matching_bundle") || abort("gem install matching_bundle")
    Dir["gemfiles/*.gemfile"].each do |gemfile|
      sh "BUNDLE_GEMFILE=#{gemfile} matching_bundle"
    end
  end
end
