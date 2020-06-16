module Memflash
  class << self
    attr_accessor :threshold
  end
  self.threshold = 300 # Messages longer than this will be stored in Rails.cache

  module CachingLayer
    def []=(key, value)
      value_for_hash = value

      if value.kind_of?(String) && value.length >= Memflash.threshold
        value_for_hash = memflash_key(key)
        Rails.cache.write(value_for_hash, value)
      end

      super(key, value_for_hash)
    end

    def [](key)
      value_in_hash = super
      if memflashed?(key, value_in_hash)
        Rails.cache.read(value_in_hash)
      else
        value_in_hash
      end
    end

    private

    def memflash_key(hash_key)
      "Memflash-#{hash_key}-#{Time.now.to_f}-#{Kernel.rand}"
    end

    def memflashed?(key, value)
      /^Memflash-#{key}/.match? value
    end
  end
end

require 'action_dispatch'
ActionDispatch::Flash::FlashHash.prepend Memflash::CachingLayer
