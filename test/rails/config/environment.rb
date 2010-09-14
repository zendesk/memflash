# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
 
Rails::Initializer.run do |config|
  config.frameworks -= [ :active_record ]
  config.action_controller.session = { :key => "_memflash_session", :secret => "ac0dcc5b4d9eef497e671126a845c3c5" }
  
  config.gem 'shoulda', :lib => 'shoulda/rails'
end