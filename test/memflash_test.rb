require "test_helper"

class MemflashTest < Test::Unit::TestCase
  class EnhancedHash < Hash
    include Memflash
  end
  
  def setup
    @hash = EnhancedHash.new
  end
  
  context "A memflash-enhanced Hash" do
    should "have a caching-enabled []" do
      assert @hash.respond_to?("[]_with_caching")
    end
    
    should "have a caching-enabled []=" do
      assert @hash.respond_to?("[]_with_caching=")
    end
  end # A memflash-enhanced Hash
  
  context "In a memflash-enhanced Hash, storing a value" do
    context "that is a String" do
      context "shorter than Memflash.threshold" do
        should "not affect the cache" do
          Rails.cache.expects(:write).never
          
          @hash[:hello] = "a" * (Memflash.threshold - 1)
        end # not affect the cache
      end # shorter than Memflash.threshold
      
      context "at least as long as Memflash.threshold" do
        setup do
          @key = "a-sample-key"
          @value = "a" * (Memflash.threshold)
        end
        
        should "call memflash_key with the key" do
          @hash.expects(:memflash_key).with(@key)
          
          @hash[@key] = @value
        end # call memflash_key with the key
        
        should "write the memflash_key and value to Rails.cache" do
          # Stubbing out memflash_key is necessary so we can set a proper expectation below.
          # Without it, the key generated when setting the expectation and the one during
          # the actual write are different, so the assertion fails
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")
          
          Rails.cache.expects(:write).with("a-memflash-key", @value)
          
          @hash[@key] = @value
        end # write the memflash_key and value to Rails.cache
        
        should "store the memflash_key in place of the original value" do
          # Stubbing out memflash_key is necessary so we can assert against the value
          # in the hash below. Without it, we don't know the memflash key that is generated,
          # so we cannot test whether it's in the hash or not.
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")
          @hash[@key] = @value
          
          assert_equal "a-memflash-key", @hash[@key]
        end # store the memflash_key in place of the original value
      end # at least as long as Memflash.threshold
    end # that is a String
    
    context "that is not a String" do
      should "not affect the cache" do
        Rails.cache.expects(:write).never
        
        @hash[:time] = Time.now.to_i
      end # not affect the cache
    end # that is not a String
  end # In a memflash-enhanced Hash, storing a value

  context "From a memflash-enhanced Hash, reading by a key" do
    should "check whether the value in the hash was memflashed" do
      @hash[:hello] = "world"
      
      @hash.expects(:memflashed?).with(:hello, "world")
      
      @hash[:hello]
    end
    
    context "whose value was memflashed" do
      setup do
        @hash.stubs(:memflashed?).returns(true)
      end
      
      should "retrieve the original value from Rails.cache" do
        key = "a-sample-memflashed-key"
        @hash[key] = "key-to-look-up-in-rails-cache"
        Rails.cache.expects(:read).with("key-to-look-up-in-rails-cache")
        
        @hash[key]
      end # retrieve the original value from Rails.cache
    end # whose value was memflashed
    
    context "whose value was not memflashed" do
      setup do
        @hash.stubs(:memflashed?).returns(false)
      end
      
      should "not read from Rails.cache" do
        Rails.cache.expects(:read).never
        
        @hash["a-non-memflashed-key"]
      end # not read from Rails.cache
    end # whose value was not memflashed
  end # From a memflash-enhanced Hash, reading a value
  
  context "ActionController::Flash::FlashHash" do
    should "be automatically cache-enhanced" do
      assert ActionController::Flash::FlashHash.ancestors.include?(Memflash)
    end
  end # ActionController::Flash::FlashHash
end
