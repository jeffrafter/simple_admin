module SimpleAdmin
  class Filters < Attributes
    # Allows you to specify a set of attributes for a section
    #
    # Available options:
    #
    #   :except An array of excluded attribute names as symbols
    #   :only An array of attribute names for this view
    #
    def initialize(interface, section, options={}, &block)
      @interface = interface
      @section = section
      @key = :filters
      defaults(options)
      instance_eval(&block) if block_given?
    end

    alias_method :filter, :attribute
  end
end
