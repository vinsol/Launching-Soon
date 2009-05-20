require File.dirname(__FILE__) + '/test_helper.rb'

class NewsLetterSubscriberTest < Test::Unit::TestCase

  def test_initialize
    news_letter_subscriber = NewsLetterSubscriber.new(:email => "satish@vinsol.com")
    assert_equal news_letter_subscriber.email, "satish@vinsol.com"
    assert_equal news_letter_subscriber.errors, []
  end

  def test_valid_for_good_emails
    emails = ["satish@vinsol.com", "sat.ish@vinsol.com", "satish_chauhan@gmail.com"]
    for email in emails
      news_letter_subscriber = NewsLetterSubscriber.new(:email => email)
      assert_equal news_letter_subscriber.valid?, true
    end
  end
  
  def test_valid_for_bad_emails
    emails = ["satish@@vinsol.com", "satish@vinsol", "s@tish@vinsol.com"]
    for email in emails
      news_letter_subscriber = NewsLetterSubscriber.new(:email => email)
      assert_equal news_letter_subscriber.valid?, false
    end
  end
  
end
