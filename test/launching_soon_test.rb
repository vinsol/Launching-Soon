require File.dirname(__FILE__) + '/test_helper.rb'
require 'action_controller/test_process'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

class LaunchingSoonController < ActionController::Base
  include LaunchingSoon

  def a
    render :nothing => true
  end

  protect_from_forgery  :secret => '7b157d290ef025841e3ff40f02dffc87'
end

class LaunchingSoonTest < Test::Unit::TestCase
  def setup
    @controller = LaunchingSoonController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_setup_launching_soon_page
    get :a
    assert_response :success
    assert_template 'launching_soon/default'
  end

end