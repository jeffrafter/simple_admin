module SimpleAdmin
  require 'simple_admin/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'simple_admin/controller'

  mattr_accessor :current_user_method,
                 :current_user_name_method,
                 :site_title,
                 :default_per_page,
                 :form_for_helper

  class << self
    def current_user_method
      @@current_user_method || raise(ConfigurationNotFound.new("current_user_method"))
    end

    def current_user_name_method
      @@current_user_name_method || raise(ConfigurationNotFound.new("current_user_name_method"))
    end

    def site_title
      @@site_title || Rails.application.class.parent_name
    end

    def default_per_page
      @@default_per_page || 25
    end

    def form_for_helper
      @@form_for_helper || :semantic_form_for
    end

    def registered
      unless defined?(@@registered) && @@registered
        @@registered = []
        # We load up all of the admin files on launch, if they change you need to restart
        begin
          Dir[Rails.root.join("app/admin/**/*.rb")].each {|f| require f}
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
    def register(resource, &block)
      interface = SimpleAdmin::Interface.new
      interface.register(resource, &block)
      self.registered << interface
    end
  end

  class ConfigurationNotFound < StandardError
    attr_accessor :message

    def initialize(option)
      @message = "SimpleAdmin configuration option #{option} not found. " +
        "Please set this in config/initializers/simple_admin.rb."
    end
  end

  class InvalidAdminFile < StandardError
    attr_accessor :message

    def initialize(e)
      @message = "#{e.message}. Try renaming app/admin/#{File.basename(e.blamed_files.first)} " +
        "to app/admin/#{File.basename(e.blamed_files.first, '.rb')}_admin.rb"
    end
  end

end
