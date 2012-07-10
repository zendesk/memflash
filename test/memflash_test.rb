require File.expand_path "../test_helper", __FILE__

class MemflashTest < Test::Unit::TestCase
  def setup
    base = if ActionPack::VERSION::MAJOR >= 3
      ActionDispatch::Flash::FlashHash
    else
      ActionController::Flash::FlashHash
    end
    @hash = base.new
  end
  
  context "Flash::FlashHash" do
    should "have a caching-enabled []" do
      assert @hash.respond_to?("[]_with_caching")
    end

    should "have a caching-enabled []=" do
      assert @hash.respond_to?("[]_with_caching=")
    end
  end

  context "storing a value" do
    context "that is a String" do
      context "shorter than Memflash.threshold" do
        should "not affect the cache" do
          Rails.cache.expects(:write).never
          
          @hash[:hello] = "a" * (Memflash.threshold - 1)
        end
      end
      
      context "at least as long as Memflash.threshold" do
        setup do
          @key = "a-sample-key"
          @value = "a" * (Memflash.threshold)
        end
        
        should "call memflash_key with the key" do
          @hash.expects(:memflash_key).with(@key)
          
          @hash[@key] = @value
        end
        
        should "write the memflash_key and value to Rails.cache" do
          # Stubbing out memflash_key is necessary so we can set a proper expectation below.
          # Without it, the key generated when setting the expectation and the one during
          # the actual write are different, so the assertion fails
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")
          
          Rails.cache.expects(:write).with("a-memflash-key", @value)
          
          @hash[@key] = @value
        end
        
        should "store the memflash_key in place of the original value" do
          # Stubbing out memflash_key is necessary so we can assert against the value
          # in the hash below. Without it, we don't know the memflash key that is generated,
          # so we cannot test whether it's in the hash or not.
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")
          @hash[@key] = @value
          
          assert_equal "a-memflash-key", @hash[@key]
        end
      end
    end
    
    context "that is not a String" do
      should "not affect the cache" do
        Rails.cache.expects(:write).never
        
        @hash[:time] = Time.now.to_i
      end
    end
  end

  context "reading a key" do
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
      end
    end
    
    context "whose value was not memflashed" do
      setup do
        @hash.stubs(:memflashed?).returns(false)
      end
      
      should "not read from Rails.cache" do
        Rails.cache.expects(:read).never
        @hash["a-non-memflashed-key"]
      end
    end
  end
end
