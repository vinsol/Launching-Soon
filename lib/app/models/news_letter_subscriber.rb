class NewsLetterSubscriber
  
  require 'ftools'
  attr_accessor :email, :errors

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
    if email  =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
      write_email_to_file # write email address to the file
      return true
    else
      false
    end
  end
  
  private ##########
  
  # writes email addresses to public/data.csv
  def write_email_to_file
    file = File.open("public/#{ LaunchingSoon::LAUNCHING_SOON_CONFIG['csv_file_name'].nil? ? 'newsLatterSubscribers.csv' : LaunchingSoon::LAUNCHING_SOON_CONFIG['csv_file_name']}", "a")
    file << "#{ email }\n"
    file.close
  end
  
end