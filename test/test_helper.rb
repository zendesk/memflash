require "active_support/test_case"
require "mocha"
require "shoulda"
require "memflash"

module Rails
  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end
end
