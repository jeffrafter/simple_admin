require 'ostruct'

module SimpleAdmin
  class Interface
    attr_reader :collection, :member, :constant, :options, :before

    def register(resource, options={}, &block)
      if resource.is_a?(Class)
        @constant = resource
        @symbol = resource.name.downcase.to_sym
      else
        @constant = resource.to_s.camelize.constantize
        @symbol = resource.to_sym
      end
      @member = @symbol.to_s
      @collection = @symbol.to_s.pluralize
      @options = options
      @sections = {}
      @before = []
      @builder = SimpleAdmin::Builder.new(self, &block)
      self
    end

    def section(sym)
      @sections[sym] ||= SimpleAdmin::Section.new(self, sym)
      @sections[sym]
    end

    def filters_for(sym)
      section(sym).options[:filters].attributes
    end

    def attributes_for(sym)
      section(sym).options[:attributes].attributes
    end

    def actions
      arr =  @options[:actions] || [:index, :show, :edit, :new, :delete, :create, :update]
      arr -= @options[:except] if @options[:except]
      arr &= @options[:only] if @options[:only]
    end
  end
end
