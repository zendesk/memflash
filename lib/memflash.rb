module Memflash
  class << self
    attr_accessor :threshold
  end
  self.threshold = 300 # Messages longer than this will be stored in Rails.cache

  module CachingLayer
    def self.included(base)
      base.class_eval do
        alias_method_chain :[]=, :caching
        alias_method_chain :[], :caching
      end
    end

    define_method "[]_with_caching=" do |key, value|
      value_for_hash = value

      if value.kind_of?(String) && value.length >= Memflash.threshold
        value_for_hash = memflash_key(key)
        Rails.cache.write(value_for_hash, value)
      end

      send("[]_without_caching=", key, value_for_hash)
    end

    define_method "[]_with_caching" do |key|
      value_in_hash = send("[]_without_caching", key)
      memflashed?(key, value_in_hash) ? Rails.cache.read(value_in_hash) : value_in_hash
    end

    private

    def memflash_key(hash_key)
      "Memflash-#{hash_key}-#{Time.now.to_f}-#{Kernel.rand}"
    end

    def memflashed?(key, value)
      !!(value =~ /^Memflash-#{key}/)
    end
  end
end

require 'action_pack/version'
base = if ActionPack::VERSION::MAJOR >= 3
  require 'action_dispatch'
  ActionDispatch::Flash::FlashHash
else
  require 'action_controller'
  ActionController::Flash::FlashHash
end
base.send :include, Memflash::CachingLayer
