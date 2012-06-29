ENV["RAILS_ENV"] = "test"
require File.expand_path(File.join(File.dirname(__FILE__), "rails2.3", "config", "environment"))

ENV["EMACS"] = "t" # show colors in test-unit < 2.4.9
require "rubygems"
require "active_support/test_case"
require "memflash"
