require 'rails/generators'
require 'rails/generators/migration'

class SimpleAdminGenerator < Rails::Generators::Base
  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def copy_initializer_file
    copy_file 'initializer.rb', 'config/initializers/simple_admin.rb'
  end
end
