require "bundler/setup"
require "minitest/autorun"
require "minitest/rg"
require "mocha/setup"
require "memflash"

module Rails
  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end
end
