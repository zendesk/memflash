require_relative 'lib/memflash/version'
Gem::Specification.new "memflash", Memflash::VERSION do |s|
  s.summary = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session"
  s.description = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session. Instead, it transparently uses `Rails.cache`, thus enabling the flash in your actions to contain large values, and still fit in a cookie-based session store"
  s.email = "vladimir@zendesk.com"
  s.homepage = "https://github.com/zendesk/memflash"
  s.authors = ["Vladimir Andrijevik"]
  s.files = `git ls-files lib README.md LICENSE`.split("\n")
  s.license = "Apache License Version 2.0"

  s.required_ruby_version = '>= 3.3'
  s.add_dependency "actionpack", ">= 7.0"
end
