require 'simple_admin'
require 'rails'

module SimpleAdmin
  class Engine < Rails::Engine
    isolate_namespace SimpleAdmin
    initializer 'simple_admin' do |app|
      if Rails.env == "development"
        simple_admin_reloader = ActiveSupport::FileUpdateChecker.new(Dir["app/admin/**/*"], {}) do
          SimpleAdmin.unregister
          Rails.application.reload_routes!
        end

        ActionDispatch::Callbacks.to_prepare do
          simple_admin_reloader.execute_if_updated
        end
      end
    end
  end
end
