module SimpleAdmin
  class Builder
    attr_accessor :interface

    def initialize(interface, &block)
      @interface = interface
      instance_eval(&block) if block_given?
    end

    def section(sym, options={}, &block)
      @interface.sections[sym] = SimpleAdmin::Section.new(@interface, sym, options, &block)
    end

    def index(options={}, &block)
      section(:index, options, &block)
    end

    def form(options={}, &block)
      section(:form, options, &block)
    end

    def show(options={}, &block)
      section(:show, options, &block)
    end

    def before(options={}, &block)
      options[:data] = block
      options[:actions] = options[:actions] || [:index, :show, :edit, :new, :destroy, :create, :update]
      options[:actions] -= options[:except] if options[:except]
      options[:actions] &= options[:only] if options[:only]
      @interface.before_filters << options
    end

    # Comfort the masses
    alias_method :before_filter, :before

  end
end
