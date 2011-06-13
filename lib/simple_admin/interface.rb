require 'ostruct'

module SimpleAdmin
  class Interface
    attr_reader :collection, :member, :constant

    def register(resource)
      if resource.is_a?(Class)
        @constant = resource
        @symbol = resource.name.downcase.to_sym
      else
        @constant = resource.to_s.camelize.constantize
        @symbol = resource.to_sym
      end
      @member = @symbol.to_s
      @collection = @symbol.to_s.pluralize
      @columns = {}
      @views = {}

      yield self
    end

    def section(sym, options={})
      @view = sym
      @views[@view] = options
      yield self
      @view = nil
    end
    alias_method :index    , :section
    alias_method :show     , :section
    alias_method :filters  , :section
    alias_method :sidebar  , :section

    def options_for(sym)
      @views[sym]
    end

    def columns_for(sym)
      @columns[sym] || default_columns_for(sym)
    end

    def column(attribute, options={}, &block)
      raise "Columns must be created within a view block" unless @view
      @columns[@view] ||= []
      col = @columns[@view].find {|col| col.attribute == attribute.to_sym }
      unless col
        col = OpenStruct.new
        @columns[@view] << col
      end
      col.attribute = attribute.to_sym
      col.options = options
      col.data = block
      col.title = options[:title] || attribute.to_s.titleize
      col.sortable = options[:sortable] || true
      col.sort_key = options[:sortable] || attribute.to_s
      col
    end

    # Expect, "only" and "except" options
    def defaults(options={})
      default_columns_for(@view, options)
    end

    protected

    # Which columns to skip when automatically rendering a form without any fields specified.
    SKIPPED_COLUMNS = [:created_at, :updated_at, :created_on, :updated_on, :lock_version, :version]

    def default_columns_for(sym, options={})
      @view = sym
      cols = constant.columns
      if @view == :form
        cols.reject! do |col|
          # TODO, check for attr_accessible / attr_protected
          SKIPPED_COLUMNS.include?(col.name.to_sym) ||
          constant.primary_key.to_s == col.name
        end
      end
      cols.each {|col| column(col.name) }
      @view = nil
      @columns[sym]
    end
  end
end
