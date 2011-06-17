require 'rails/generators'
require 'rails/generators/migration'

class SimpleAdminGenerator < Rails::Generators::Base
  desc <<-CONTENT
  This will mount SimpleAdmin in your routes.rb using the admin \
  path. It will also install a simple_admin initializer file in \
  your config where you can setup the options.\
  \
  Once complete, register admin interfaces like app/admin/posts.rb:\
  \
    SimpleAdmin.register :posts do\
    end\

  CONTENT

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def copy_initializer_file
    copy_file 'initializer.rb', 'config/initializers/simple_admin.rb'
  end

  def app_admin
    empty_directory('app/admin')
  end

  def add_simple_admin_routes
    simple_admin_routes = %(mount SimpleAdmin::Engine => '/admin'\n)
    route simple_admin_routes
  end
end
