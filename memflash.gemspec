Gem::Specification.new "memflash", "2.0.0" do |s|
  s.summary = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session"
  s.description = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session. Instead, it transparently uses `Rails.cache`, thus enabling the flash in your actions to contain large values, and still fit in a cookie-based session store"
  s.email = "vladimir@zendesk.com"
  s.homepage = "https://github.com/zendesk/memflash"
  s.authors = ["Vladimir Andrijevik"]
  s.files = `git ls-files lib README.md LICENSE`.split("\n")
  s.license = "Apache License Version 2.0"
  s.add_dependency "actionpack", ">= 3.2.15", "< 4.1"

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  s.add_development_dependency('minitest-rg')
  s.add_development_dependency('wwtd')
  s.add_development_dependency('bump')
  s.add_development_dependency('mocha')
end
