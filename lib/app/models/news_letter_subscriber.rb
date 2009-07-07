class NewsLetterSubscriber
  
  attr_accessor :email, :errors, :name

  def initialize(attributes = nil)
    if Hash === attributes
      attributes.each do |key, value|
        self.send(key.to_s + "=", value)
      end
    end
    @errors = []
    load_monkey_brains
  end
  
  # validate email address
  def valid?
    self.errors.clear
    if email.blank?
      self.errors << "Email address can't be blank"
    elsif !(email  =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/)
      self.errors << "Invalid email address"
    end
    remove_duplicate_errors
    return errors.empty?
  end

  # save email address to CSV/CampaignMonitor/MailChimp
  def save
    valid? ? write_email_address : false
  end

  #------------------------ private ----------------------
  private

  # actual stuff to writes email addresses to subscribers list (CSV/CampaignMonitor/MailChimp)
  def write_email_address
    if option_to_store_email?('campaign_monitor') # @campaign_monitor_api_key && @campaign_monitor_list_id
      write_email_to_campaign_monitor
    elsif option_to_store_email?('mail_chimp') # @mail_chimp_api_key && @cmail_chimp_list_id
      write_email_to_mail_chimp
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
      self.errors << e.message
    end
    remove_duplicate_errors
  end

  # writes email addresses to MailChimp subscribers list
  def write_email_to_mail_chimp
    require 'xmlrpc/client'
    chimpApi ||= XMLRPC::Client.new2("http://api.mailchimp.com/1.2/")
    begin
      chimpApi.call("listSubscribe", @mail_chimp_api_key, @mail_chimp_list_id, email, {}, 'html', false, true, true)
    rescue Exception => e
      self.errors << e.message
    end
    remove_duplicate_errors
  end

  # writes email addresses to CSV file
  def write_email_to_csv_file
    require 'ftools'
    begin
      file = File.open("public/#{ @csv_file_name.nil? ? 'newsLatterSubscribers.csv' : @csv_file_name }", "a")
      file << "#{ email }\n"
      file.close
    rescue Exception => e
      self.errors << e.message
    end
  end

  # delete duplicate entries from errors
  def remove_duplicate_errors
    self.errors.flatten!
    self.errors.uniq!
  end

  def option_to_store_email?(option = 'csv')
    @option_to_store_email == option
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