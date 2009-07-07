require 'test/unit'
begin
  require File.dirname(__FILE__) + '/../../../../config/environment'
rescue LoadError
  require 'rubygems'
  gem 'activerecord'
  gem 'actionpack'
  require 'active_record'
  require 'action_controller'
  require 'action_controller/test_process'
  require 'active_support'
end
#RAILS_ENV = 'test'
require File.join(File.dirname(__FILE__), '../lib/launching_soon')
RAILS_ROOT = File.join(File.dirname(__FILE__), '..') unless defined? RAILS_ROOT
require File.join(File.dirname(__FILE__), '../init')