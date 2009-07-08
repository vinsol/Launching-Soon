# LaunchingSoon

require "launching_soon/commands" 
require 'launching_soon/routing'

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

LAUNCHING_SOON_CONFIG = YAML.load_file(File.join(RAILS_ROOT, 'config', 'launching_soon.yml'))[RAILS_ENV].symbolize_keys
CAMPAIGN_MONITOR_API_KEY = LAUNCHING_SOON_CONFIG[:campaign_monitor_api_key]

module LaunchingSoon

  #
  # The LaunchingSoon plugin provides a launching soon page with a form
  # that except email from users so that you can update users after you launched the website.
  #
  # Configuration:
  #
  # First, include the LaunchingSoon in ApplicationController:
  #
  # class ApplicationController < ActionController::Base
  #   include LaunchingSoon
  #   ...
  # end
  #
  # Add following routes to your applications routes.rb
  #
  # ActionController::Routing::Routes.draw do |map|
  #   map.resources :news_letter_subscribers, :only => [:create]
  #   ...
  # end
  #
  # OR
  #
  # ruby script/generate launching_soon_routes
  #

  # includes before filter setup_launching_soon_page to the controller
  def self.included(controller)
    controller.before_filter(:setup_launching_soon_page)# if Rails.env == 'production'
  end
  
  private #################
  
  # This will render the launching soon page from views/LAUNCHING_SOON_CONFIG[:html_file_name]) path (eg. app/views/launching_soon/default.html.erb)
  # with a css file from public/stylesheets/LAUNCHING_SOON_CONFIG[:css_file_name] path (eg. public/stylesheets/launching_soon.css).
  def setup_launching_soon_page
    @css_file = LAUNCHING_SOON_CONFIG[:css_file_name]
    @launching_date = LAUNCHING_SOON_CONFIG[:launching_date]
    render :template => File.join('launching_soon', LAUNCHING_SOON_CONFIG[:html_file_name]), :layout => "launching_soon"
  end
  
end