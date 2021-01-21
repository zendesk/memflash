require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

desc "Bundle, tag, and commit after you update the version"
task :version => [:bundle_all] do
  version_name = "v#{Memflash::VERSION}"
  sh "git add --update && git commit -m '#{version_name}'"
  sh "git tag -a -m 'Bump to #{version_name}' #{version_name}"
  puts "-"*80
  puts "Remember to 'git push --tags'"
  puts "-"*80
end

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
