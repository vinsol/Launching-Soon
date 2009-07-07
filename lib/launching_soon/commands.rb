require 'rails_generator' 
require 'rails_generator/commands'
module LaunchingSoon #:nodoc:  
  module Generator #:nodoc:  
    module Commands #:nodoc:
      module Create 
        def launching_soon_routes
	        logger.route "map.resources :news_letter_subscribers, :only => [:create]"
          look_for = 'ActionController::Routing::Routes.draw do |map|'  
          unless options[:pretend] 
            gsub_file("config/routes.rb", /(#{Regexp.escape(look_for)})/mi){|match| "#{match}\n map.resources :news_letter_subscribers, :only => [:create]\n"}
          end
        end
      end
      
      module Destroy 
        def launching_soon_routes
          logger.route "map.resources :news_letter_subscribers, :only => [:create]"
          gsub_file 'config/routes.rb', /\n.+?map\.resources :news_letter_subscribers, :only => \[:create\]/mi, ''
        end
      end
      
      module List
        def launching_soon_routes
        end
      end
      
      module Update
        def launching_soon_routes
        end
      end
    end
  end
end 

Rails::Generator::Commands::Create.send   :include, LaunchingSoon::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include, LaunchingSoon::Generator::Commands::Destroy
Rails::Generator::Commands::List.send     :include, LaunchingSoon::Generator::Commands::List
Rails::Generator::Commands::Update.send   :include, LaunchingSoon::Generator::Commands::Update