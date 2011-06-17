module SimpleAdmin
  class Attributes
    # Which columns to skip when automatically rendering a form without any fields specified
    SKIPPED_COLUMNS = [:created_at, :updated_at, :created_on, :updated_on, :lock_version, :version]

    attr_reader :attributes

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
      defaults(options)
      instance_eval(&block) if block_given?
    end

    # Clear the attributes for this section
    def clear
      @attributes = []
    end

    # Define or override an attribute for this section
    def attribute(name, options={}, &block)
      attr = @attributes.find {|attr| attr.attribute == name.to_sym }
      unless attr
        attr = OpenStruct.new
        @attributes << attr
      end
      attr.attribute = name.to_sym
      attr.options = options
      attr.data = block
      attr.title = options[:title] || name.to_s.titleize
      attr.sortable = options[:sortable] || true
      attr.sort_key = options[:sortable] || name.to_s
      attr
    end

    # Define the default attributes for this section
    def defaults(options={})
      clear
      if @section.section == :form
        association_columns = @interface.constant.reflections.map do |name, ref|
          if ref.macro == :belongs_to && ref.options[:polymorphic] != true
            name.to_sym
          end
        end.compact

        cols = @interface.constant.content_columns.map {|col| col.name.to_sym }
        cols += association_columns
        cols -= SKIPPED_COLUMNS
        cols.compact!
      else
        cols = @interface.constant.columns.map{|col| col.name.to_sym }
      end
      cols -= options[:except] if options[:except]
      cols &= options[:only] if options[:only]
      cols.each {|col| attribute(col.to_s) }
    end
  end
end
