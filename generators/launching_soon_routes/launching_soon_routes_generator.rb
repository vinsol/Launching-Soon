class LaunchingSoonRoutesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.launching_soon_routes
    end
  end
end