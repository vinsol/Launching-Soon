module LaunchingSoon
  module Routing #:nodoc:  
    module MapperExtensions 
      def news_letter_subscribers 
        @set.add_route('/news_letter_subscribers', {:controller => 'news_letter_subscribers', :action => 'index'})  
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send  :include, LaunchingSoon::Routing::MapperExtensions