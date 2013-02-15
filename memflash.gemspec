Gem::Specification.new "memflash", "2.0.0" do |s|
  s.summary = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session"
  s.description = "Memflash is a gem which enables storing really long values in the Rails FlashHash without writing them to the session. Instead, it transparently uses `Rails.cache`, thus enabling the flash in your actions to contain large values, and still fit in a cookie-based session store"
  s.email = "vladimir@zendesk.com"
  s.homepage = "http://github.com/zendesk/memflash"
  s.authors = ["Vladimir Andrijevik"]
  s.files = `git ls-files`.split("\n")
  s.license = "Apache License Version 2.0"
  s.add_dependency "actionpack", ">= 2.3.6", "< 3.3"

  s.add_development_dependency('rake')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('appraisal')
  s.add_development_dependency('bundler')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('mocha', '~>0.13.2')
end
