class NewsLetterSubscribersController < ActionController::Base 
  
  skip_before_filter :setup_launching_soon_page
  
  # This will write a valid email address to LAUNCHING_SOON_CONFIG[:csv_file_name] file (eg. public/data.csv).
  def create
    @nls = NewsLetterSubscriber.new(:email => params[:email])
    respond_to do |format|
      format.html { render :nothing => true }
      format.js do
        render :update do |page|
          page.replace_html "message", @nls.save ? render_success_message : render_error_message
        end
      end
    end
  end
  
end