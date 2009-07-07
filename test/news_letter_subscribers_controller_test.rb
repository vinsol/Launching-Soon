require File.dirname(__FILE__) + '/test_helper.rb'
require 'news_letter_subscribers_controller'

class NewsLetterSubscribersControllerTest < Test::Unit::TestCase 

  def setup 
    @controller = NewsLetterSubscribersController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_create_with_get_request
    get :create
    assert_response :success
    assert_template ''
  end

  def test_create_with_post_request_without_email
    xhr :post, :create, {}
    assert_response :success
    assert_select "div#errorMessage", "Invalid email address"
  end

  def test_create_with_post_request_with_invalid_email
    xhr :post, :create, {}
    assert_response :success
    assert_select "div#errorMessage", "Invalid email address"
  end
  
  def test_create_with_post_request_with_valid_email
    xhr :post, :create, {:email => 'satish@vinsol.com'}
    assert_response :success
    assert_select "div#successMessage", "Subscribed successfully"
  end

end
