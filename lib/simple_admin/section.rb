module SimpleAdmin
  class Section
    attr_accessor :options, :section

    def initialize(interface, section, options={}, &block)
      @interface = interface
      @section = section
      @options = options
      @allow_filters = (section == :index)
      attributes
      filters if @allow_filters
      instance_eval(&block) if block_given?
    end

    def attributes(attr_options={}, &block)
      self.options[:attributes] = SimpleAdmin::Attributes.new(@interface, self, attr_options, &block)
    end

    def filters(filter_options={}, &block)
      raise "Filters cannot be specified for this section" unless @allow_filters
      self.options[:filters] = SimpleAdmin::Filters.new(@interface, self, filter_options, &block)
    end

    def sidebar(sidebar_options={}, &block)
      sidebar_options[:data] = block
      self.options[:sidebars] = []
      self.options[:sidebars] << sidebar_options
    end
  end
end
