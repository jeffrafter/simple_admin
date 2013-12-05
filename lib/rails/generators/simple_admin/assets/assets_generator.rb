require 'rails/generators'

module SimpleAdmin
  class AssetsGenerator < Rails::Generators::Base
    desc <<-CONTENT
    This will install the admin assets into your public \
    folder. If you want to move these files you can adjust \
    your config/initializer/simple_admin.rb and modify the \
    config.javascripts and config.stylesheets. \
    \
    The default theme comes from ActiveAdmin.

    CONTENT

    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..')
    end

    def copy_assets_folder
      directory 'app/assets', 'public'
    end

  end
end
