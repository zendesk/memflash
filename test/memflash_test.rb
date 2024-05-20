require_relative "test_helper"

describe Memflash do
  before do
    @hash = ActionDispatch::Flash::FlashHash.new
  end

  describe "storing a value" do
    describe "that is a String" do
      describe "shorter than Memflash.threshold" do
        it "not affect the cache" do
          Rails.cache.expects(:write).never

          @hash[:hello] = "a" * (Memflash.threshold - 1)
        end
      end

      describe "shorter than Memflash.threshold" do
        it "not affect the cache" do
          @hash[:hello] = true

          assert_equal true, @hash[:hello]
        end
      end

      describe "at least as long as Memflash.threshold" do
        before do
          @key = "a-sample-key"
          @value = "a" * (Memflash.threshold)
        end

        it "call memflash_key with the key" do
          @hash.expects(:memflash_key).with(@key).returns("Memflash-#{@key}-#{Time.now.to_f}-#{Kernel.rand}")

          @hash[@key] = @value
        end

        it "write the memflash_key and value to Rails.cache" do
          # Stubbing out memflash_key is necessary so we can set a proper expectation below.
          # Without it, the key generated when setting the expectation and the one during
          # the actual write are different, so the assertion fails
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")

          Rails.cache.expects(:write).with("a-memflash-key", @value)

          @hash[@key] = @value
        end

        it "store the memflash_key in place of the original value" do
          # Stubbing out memflash_key is necessary so we can assert against the value
          # in the hash below. Without it, we don't know the memflash key that is generated,
          # so we cannot test whether it's in the hash or not.
          @hash.stubs(:memflash_key).with(@key).returns("a-memflash-key")
          @hash[@key] = @value

          assert_equal "a-memflash-key", @hash[@key]
        end
      end
    end

    describe "that is not a String" do
      it "not affect the cache" do
        Rails.cache.expects(:write).never

        @hash[:time] = Time.now.to_i
      end
    end
  end

  describe "reading a key" do
    it "check whether the value in the hash was memflashed" do
      @hash[:hello] = "world"

      @hash.expects(:memflashed?).with(:hello, "world")

      @hash[:hello]
    end

    describe "whose value was memflashed" do
      before do
        @hash.stubs(:memflashed?).returns(true)
      end

      it "retrieve the original value from Rails.cache" do
        key = "a-sample-memflashed-key"
        @hash[key] = "key-to-look-up-in-rails-cache"
        Rails.cache.expects(:read).with("key-to-look-up-in-rails-cache")

        @hash[key]
      end
    end

    describe "whose value was not memflashed" do
      before do
        @hash.stubs(:memflashed?).returns(false)
      end

      it "not read from Rails.cache" do
        Rails.cache.expects(:read).never
        @hash["a-non-memflashed-key"]
      end
    end
  end
end
