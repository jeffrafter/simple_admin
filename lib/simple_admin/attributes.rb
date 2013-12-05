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
      self
    end

    # Clear the attributes for this section
    def clear
      @attributes = []
      @attributes_hash = {}
    end

    # Define or override an attribute for this section
    #
    # Available options:
    #
    #   :sortable +true+ or +false+ (defaults to +true+)
    #   :sort_key a column name used when sorting this column (defaults to the column for this attribute)
    #
    def attribute(name, options={}, &block)
start = Time.now
      key = "#{name}:#{options[:mode]}"
      attr = @attributes_hash[key]
      unless attr
        attr = {}
        @attributes << attr
        @attributes_hash[key] = attr
      end
      attr[:kind] = :attribute
      attr[:attribute] = name.to_sym
      attr[:options] = options
      attr[:data] = block
      attr[:title] = options[:title] || name.to_s.titleize
      attr[:sortable] = options[:sortable].nil? || !(options[:sortable] === false)
      attr[:editable] = options[:editable] === true
      attr[:mode] = options[:mode]
      attr[:sort_key] = (options[:sort_key] || name).to_s
      attr
    end

    # Include rendered content inline.
    #
    # This is only used when displaying a form.
    #
    def content(options={}, &block)
      cont = {}
      @attributes << cont
      cont[:kind] = :content
      cont[:options] = options
      cont[:data] = block
      cont[:mode] = options[:mode]
      cont
    end

    # Create a section which may or may not contain sub-sections.
    #
    # Note: this works better if you first clear the attributes. For example:
    #
    #  attributes do
    #    clear
    #    section :kind => :fieldset, :legend => "Primary Address" do
    #      attribute :address
    #      section :class => 'csz' do
    #        attribute :city
    #        attribute :state
    #        attribute :zip
    #      end
    #    end
    #  end
    def section(options={}, &block)
      sect = {}
      @attributes << sect
      sect[:kind] = options.delete(:kind) || :section
      sect[:options] = options
      sect[:mode] = options[:mode]
      sect[:attributes] = []
      save_attributes = @attributes
      @attributes = sect[:attributes]
      instance_eval(&block) if block_given?
      @attributes = save_attributes
      sect
    end


    # Define the default attributes for this section
    #
    # If the current section is a form it will only use content columns and will
    # skip timestamps and primary key fields.
    #
    # Available options:
    #
    #   :except An array of excluded attribute names as symbols
    #   :only An array of attribute names for this view
    #
    def defaults(options={})
      clear
      if @section.section == :form
        reflections = @interface.constant.reflections rescue []
        association_columns = reflections.map do |name, ref|
          if ref.macro == :belongs_to && ref.options[:polymorphic] != true
            name.to_sym
          end
        end.compact

        content_columns = @interface.constant.content_columns rescue []
        cols = content_columns.map {|col| col.name.to_sym }
        cols += association_columns
        cols -= SKIPPED_COLUMNS
        cols.compact!
      else
        cols = @interface.constant.columns.map{|col| col.name.to_sym } rescue []
      end
      cols -= options[:except] if options[:except]
      cols &= options[:only] if options[:only]
      cols.each {|col| attribute(col.to_s) }
    end
  end
end
