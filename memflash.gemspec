Gem::Specification.new "memflash", "1.0.0" do |s|
  s.summary = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session"
  s.description = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session. Instead, it transparently uses `Rails.cache`, thus enabling the flash in your actions to contain large values, and still fit in a cookie-based session store"
  s.email = "vladimir@zendesk.com"
  s.homepage = "http://github.com/zendesk/memflash"
  s.authors = ["Vladimir Andrijevik"]
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
  s.add_dependency "actionpack", ">= 2.3.6", "< 3.3"
end
