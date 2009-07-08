# Install hook code here
puts 'Copying stylesheet'
FileUtils.cp File.join(File.dirname(__FILE__), 'public', 'stylesheets', 'launching_soon.css'),  File.join(RAILS_ROOT, 'public', 'stylesheets')
puts 'Copying javascripts'
FileUtils.cp File.join(File.dirname(__FILE__), 'public', 'javascripts', 'countdown.js'),  File.join(RAILS_ROOT,  'public', 'javascripts')
puts 'Copying config file'
FileUtils.cp File.join(File.dirname(__FILE__), 'config', 'launching_soon.yml'), File.join(RAILS_ROOT, 'config')
puts 'Copying views'
FileUtils.cp File.join(File.dirname(__FILE__), 'lib', 'app', 'views', 'layouts', 'launching_soon.html.erb'), File.join(RAILS_ROOT, 'app', 'views', 'layouts')
FileUtils.cp File.join(File.dirname(__FILE__), 'lib', 'app', 'views', 'default.html.erb'), FileUtils.mkdir_p(File.join(RAILS_ROOT,  'app', 'views',  'launching_soon'))
puts 'Copying images'
destination = File.join(RAILS_ROOT, 'public/images/launching_soon')
source = File.dirname(__FILE__) + '/public/images/'
FileUtils.mkdir_p(destination)
FileUtils.cp_r(Dir.glob(source + '*.*'), destination)