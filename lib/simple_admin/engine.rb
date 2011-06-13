require 'simple_admin'
require 'rails'

module SimpleAdmin
  class Engine < Rails::Engine
    isolate_namespace SimpleAdmin
  end
end
