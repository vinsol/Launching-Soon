module NewsLetterSubscribersHelper

  def render_success_message
    html = "<div id='successMessage'>"
    html << "Subscribed successfully"
    html << "</div>"
  end
  
  def render_error_message
    html = "<div id='errorMessage'>"
    html << '<ol>'
    @nls.errors.each do |error|
      html << "<li>"
      html << h(error)
      html << "</li>"
    end
    html << "</ol>"
    html << "</div>"
  end
  
end
