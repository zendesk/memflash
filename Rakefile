require 'rubygems'
require 'rake'
require 'appraisal'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "memflash"
    gem.summary = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session"
    gem.description = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session. Instead, it transparently uses `Rails.cache`, thus enabling the flash in your actions to contain large values, and still fit in a cookie-based session store"
    gem.email = "vladimir@zendesk.com"
    gem.homepage = "http://github.com/zendesk/memflash"
    gem.authors = ["Vladimir Andrijevik"]
    gem.version = "1.0.0"
    gem.add_dependency "actionpack", ">= 2.3.6", "< 3.3"

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test
