class NewsLetterSubscriber
  
  require 'campaigning'
  Campaigning::Subscriber::CAMPAIGN_MONITOR_API_KEY = LaunchingSoon::LAUNCHING_SOON_CONFIG['campaign_monitor_api_key']
  LIST_ID = LaunchingSoon::LAUNCHING_SOON_CONFIG['campaign_monitor_list_id']

  require 'ftools'
  attr_accessor :email, :errors, :name

  def initialize(attributes = nil)
    if Hash === attributes
      attributes.each do |key, value|
        self.send(key.to_s + "=", value)
      end
    end
    @errors = []
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

 # save email address to public/data.csv or campaignmonitor
  def save
    valid? ? write_email_address : false
  end

  private ##########
  
  def remove_duplicate_errors
    self.errors.flatten!
    self.errors.uniq!
  end

  # actual stuff to writes email addresses to public/data.csv or campaignmonitor's subscribers list
  def write_email_address
    if LaunchingSoon::LAUNCHING_SOON_CONFIG['campaign_monitor_api_key'] && LaunchingSoon::LAUNCHING_SOON_CONFIG['campaign_monitor_list_id']
      subscriber = Campaigning::Subscriber.new(email, name)
      begin
        result = subscriber.add!(LIST_ID)
        unless result.message == 'Success'
          self.errors << result.message
        end
      rescue Exception => e
        self.errors << e.message
      end
      remove_duplicate_errors
      return errors.empty?
    else
      file = File.open("public/#{ LaunchingSoon::LAUNCHING_SOON_CONFIG['csv_file_name'].nil? ? 'newsLatterSubscribers.csv' : LaunchingSoon::LAUNCHING_SOON_CONFIG['csv_file_name']}", "a")
      file << "#{ email }\n"
      file.close
      return errors.empty?
    end
  end
  
end