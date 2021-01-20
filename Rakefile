require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

# Because Bump ignores gemfiles
module BumpAllGemfiles
  def commit(version, file, options)
    return unless File.directory?(".git")
    system("rake bundle_all") if options[:bundle]
    system("git add --update gemfiles") if options[:bundle]
    super
  end
end
Bump::Bump.singleton_class.prepend(BumpAllGemfiles)

desc "Bundle all gemfiles"
task :bundle_all do
  Bundler.with_original_env do
    system("which -s matching_bundle") || abort("gem install matching_bundle")
    sh "BUNDLE_GEMFILE=Gemfile matching_bundle"
    Dir["gemfiles/*.gemfile"].each do |gemfile|
      sh "BUNDLE_GEMFILE=#{gemfile} matching_bundle"
    end
  end
end

namespace :test do
  desc "Run tests with all gemfiles"
  task :all do
    Bundler.with_original_env do
      system("which -s matching_bundle") || abort("gem install matching_bundle")
      Dir["gemfiles/*.gemfile"].each do |gemfile|
        sh "BUNDLE_GEMFILE=#{gemfile} rake test"
      end
    end
  end
end
