module SimpleAdmin
  require 'simple_admin/engine' if defined?(Rails)
  require 'simple_admin/interface'
  require 'simple_admin/builder'
  require 'simple_admin/section'
  require 'simple_admin/attributes'
  require 'simple_admin/filters'
  require 'simple_admin/breadcrumbs'


  mattr_accessor :require_user_method,
                 :current_user_method,
                 :current_user_name_method,
                 :site_title,
                 :default_per_page,
                 :form_for_helper,
                 :stylesheet,
                 :javascript

  class << self
    def site_title
      @@site_title || Rails.application.class.parent_name.titleize
    end

    def default_per_page
      @@default_per_page || 25
    end

    def form_for_helper
      @@form_for_helper || :semantic_form_for
    end

    def stylesheet
      @@stylesheet || "/stylesheets/simple_admin/active_admin.css"
    end

    def javascript
      @@javascript || "/javascripts/simple_admin/active_admin.js"
    end

    def registered
      unless defined?(@@registered) && @@registered
        @@registered = []
        # We load up all of the admin files on launch, if they change you need to restart
        begin
          Dir[Rails.root.join("app/admin/**/*.rb")].each {|f| load f}
        rescue LoadError => e
          # For certain kinds of load errors, we want to give a more helpful message
          if e.message.match(/Expected .* to define .*/)
            raise(InvalidAdminFile.new(e))
          else
            raise e
          end
        end
      end
      @@registered
    end

    # Clear the routes and registered interfaces
    def unregister
      @@registered = nil
    end

    # Called by the initializer
    #
    #   SimpleAdmin.setup do |config|
    #     config.site_title = "My Website"
    #   end
    #
    def setup
      yield self
    end

    # Registers a model for administration:
    #
    #     SimpleAdmin.register :post do
    #     end
    #
    # Various configuration options are available within the block
    def register(resource, options={}, &block)
      if defined?(@@registered)
        interface = SimpleAdmin::Interface.new(resource, options, &block)
        self.registered << interface
        interface
      end
    end
  end

  class ConfigurationNotFound < StandardError
    attr_accessor :message

    def initialize(option)
      @message = "SimpleAdmin configuration option #{option} not found. " +
        "Please set this in config/initializers/simple_admin.rb."
    end
  end

  class InvalidAdminFile < LoadError
    attr_accessor :message

    def initialize(e)
      @message = "#{e.message}. Try renaming app/admin/#{File.basename(e.blamed_files.first)} " +
        "to app/admin/#{File.basename(e.blamed_files.first, '.rb')}s.rb"
    end
  end

  class UnknownAdminInterface < StandardError
    attr_accessor :message

    def initialize(e)
      @message = "SimpleAdmin interface unknown, make sure you mount SimpleAdmin in your routes and that you have registered an interface for this resource"
    end
  end

  class ActionNotAllowed < StandardError
    attr_accessor :message

    def initialize(action)
      @message = "SimpleAdmin #{action} action undefined, make sure you have allowed this action in your interface definition."
    end
  end
end
