require File.dirname(__FILE__) + '/test_helper.rb'

class NewsLetterSubscriberTest < Test::Unit::TestCase

  def test_initialize
    news_letter_subscriber = NewsLetterSubscriber.new(:email => "satish@vinsol.com")
    assert_equal news_letter_subscriber.email, "satish@vinsol.com"
    assert_equal news_letter_subscriber.name, nil
    assert_equal news_letter_subscriber.errors, []
  end

  def test_presence_of_email
    news_letter_subscriber = NewsLetterSubscriber.new()
    assert_equal news_letter_subscriber.valid?, false
    assert_equal news_letter_subscriber.errors, ["Email address can't be blank"]
  end

  def test_valid_for_good_emails
    emails = ["satish@vinsol.com", "sat.ish@vinsol.com", "satish_chauhan@gmail.com"]
    for email in emails
      news_letter_subscriber = NewsLetterSubscriber.new(:email => email)
      assert_equal news_letter_subscriber.valid?, true
      assert_equal news_letter_subscriber.errors.size, 0
    end
  end
  
  def test_valid_for_bad_emails
    emails = ["satish@@vinsol.com", "satish@vinsol", "s@tish@vinsol.com"]
    for email in emails
      news_letter_subscriber = NewsLetterSubscriber.new(:email => email)
      assert_equal news_letter_subscriber.valid?, false
      assert_equal news_letter_subscriber.errors, ["Invalid email address"]
    end
  end

#  def test_save
#    news_letter_subscriber = NewsLetterSubscriber.new(:email => "satish@vinsol.com")
#    assert_equal news_letter_subscriber.valid?, true
#  end

end
