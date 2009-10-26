class LaunchingSoon::NewsLetterSubscriber < ActiveRecord::Base
  
  validates_presence_of :email
  validates_uniqueness_of :email, :if => :store_to_db
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  attr_accessor_with_default :store_to_db, false

  alias :original_save :save
  
  def valid?
    load_monkey_brains
    self.store_to_db = (@option_to_store_email == 'db')
    super
  end

  # save email address to CSV/CampaignMonitor/MailChimp/db
  def save
    valid? ? write_email_address : false
  end

  #------------------------ private ----------------------
  private

  # actual stuff to writes email addresses to subscribers list (CSV/CampaignMonitor/MailChimp)
  def write_email_address
    case @option_to_store_email
    when 'campaign_monitor'
      write_email_to_campaign_monitor  # @campaign_monitor_api_key && @campaign_monitor_list_id
    when 'mail_chimp'
      write_email_to_mail_chimp # @mail_chimp_api_key && @cmail_chimp_list_id
    when 'db' #
      write_email_to_database
    else
      write_email_to_csv_file
    end
    return errors.empty?
  end

  # writes email addresses to CampaignMonitor subscribers list
  def write_email_to_campaign_monitor
    require 'campaigning'
    subscriber = Campaigning::Subscriber.new(email, name)
    begin
      result = subscriber.add!(@campaign_monitor_list_id)
      unless result.message == 'Success'
        self.errors << result.message
      end
    rescue Exception => e
      self.errors.add_to_base(e.message + " (Campaign Monitor)")
    end
  end

  # writes email addresses to MailChimp subscribers list
  def write_email_to_mail_chimp
    require 'xmlrpc/client'
    chimpApi ||= XMLRPC::Client.new2("http://api.mailchimp.com/1.2/")

    begin
      chimpApi.call("listSubscribe", @mail_chimp_api_key, @mail_chimp_list_id, email, {}, 'html', false, true, true)
    rescue Exception => e
      self.errors.add_to_base(e.message + " (MailChimp)")
    end
  end

  # writes email addresses to database
  def write_email_to_database
    self.original_save
  end

  # writes email addresses to CSV file
  def write_email_to_csv_file
    require 'ftools'
    begin
      file = File.open("public/#{ @csv_file_name.nil? ? 'newsLatterSubscribers.csv' : @csv_file_name }", "a")
      file << "#{ email }\n"
      file.close
    rescue Exception => e
      self.errors.add_to_base(e.message + " (CSV)")
    end
  end

  def load_monkey_brains
    @option_to_store_email    = LAUNCHING_SOON_CONFIG[:option_to_store_email]
    @campaign_monitor_api_key = LAUNCHING_SOON_CONFIG[:campaign_monitor_api_key]
    @campaign_monitor_list_id = LAUNCHING_SOON_CONFIG[:campaign_monitor_list_id]
    @mail_chimp_api_key       = LAUNCHING_SOON_CONFIG[:mail_chimp_api_key]
    @mail_chimp_list_id       = LAUNCHING_SOON_CONFIG[:mail_chimp_list_id]
    @csv_file_name            = LAUNCHING_SOON_CONFIG[:csv_file_name]
  end
end