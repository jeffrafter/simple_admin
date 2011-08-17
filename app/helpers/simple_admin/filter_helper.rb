module SimpleAdmin
  module FilterHelper
    def filter_for(method, klass, options={})
      options ||= {}
      options = options.dup
      options[:as] ||= default_filter_type(klass, method)
      expand_block_options!(options)
      return "" unless options[:as]
      field_type = options.delete(:as)
      wrapper_options = options[:wrapper_html] || {}
      wrapper_options[:class] = (wrapper_options[:class] || "") + " filter_form_field filter_#{field_type}"
      content_tag :div, wrapper_options do
        send("filter_#{field_type}_input", klass, method, options)
      end
    end

    def filter_string_input(klass, method, options = {})
      field_name = "#{method}_contains"

      [ label(field_name, options[:title] || "Search #{method.to_s.titlecase}"),
        text_field_tag(field_name, params[field_name] || '')
      ].join("\n").html_safe
    end

    def filter_date_range_input(klass, method, options = {})
      gt_field_name = "#{method}_gte"
      lt_field_name = "#{method}_lte"

      [ label(gt_field_name, options[:title] || method.to_s.titlecase),
        filter_date_text_field(klass, gt_field_name),
        " - ",
        filter_date_text_field(klass, lt_field_name)
      ].join("\n").html_safe
    end

    def filter_date_text_field(klass, method)
      current_value = params[method] || ''
      text_field_tag(method, current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : current_value, :size => 12, :class => "datepicker", :max => 10)
    end

    def filter_numeric_input(klass, method, options = {})
      filters = numeric_filters_for_method(method, options.delete(:filters) || default_numeric_filters)
      current_filter = current_numeric_scope(klass, filters)
      filter_select = select_tag '', options_for_select(filters, current_filter), :onchange => "document.getElementById('#{method}_numeric').name = '' + this.value + '';"
      filter_input = text_field_tag(current_filter, params[current_filter] || '', :size => 10, :id => "#{method}_numeric")

      [ label_tag(method, options[:title]), filter_select, " ", filter_input].join("\n").html_safe
    end

    def numeric_filters_for_method(method, filters)
      filters.collect{|scope| [scope[0], [method,scope[1]].join("_") ] }
    end

    # Returns the scope for which we are currently searching. If no search is available
    # it returns the first scope
    def current_numeric_scope(klass, filters)
      filters[1..-1].inject(filters.first){|a,b| params[b[1].to_sym] ? b : a }[1]
    end

    def default_numeric_filters
      [['Equal To', 'eq'], ['Greater Than', 'gt'], ['Less Than', 'lt']]
    end

    def filter_select_input(klass, method, options = {})
      association_name = method.to_s.gsub(/_id$/, '').to_sym
      input_name = if reflection = reflection_for(klass, association_name)
        if [:has_and_belongs_to_many, :has_many].include?(reflection.macro)
          "#{association_name.to_s.singularize}_ids"
        else
          reflection.options[:foreign_key] || "#{association_name}_id"
        end
      else
        association_name
      end
      input_name = (input_name.to_s + "_eq").to_sym
      collection = find_collection_for_column(klass, association_name, options)
      [ label(input_name, options[:title] || method.to_s.titlecase),
        select_tag(input_name, options_for_select(collection, params[input_name]), :include_blank => options[:include_blank] || 'Any')
      ].join("\n").html_safe
    end

    def generate_association_input_name(klass, method) #:nodoc:
      if reflection = reflection_for(klass, method)
        if [:has_and_belongs_to_many, :has_many].include?(reflection.macro)
          "#{method.to_s.singularize}_ids"
        else
          reflection.options[:foreign_key] || "#{method}_id"
        end
      else
        method
      end.to_sym
    end

    def find_collection_for_column(klass, column, options) #:nodoc:
      collection = if options[:collection]
        collection = options.delete(:collection)
        collection = collection.to_a if collection.is_a?(Hash)
        collection.map { |o| [pretty_format(o.first), o.last] }
      elsif reflection = reflection_for(klass, column)
        options[:find_options] ||= {}
        if conditions = reflection.options[:conditions]
          options[:find_options][:conditions] = reflection.klass.merge_conditions(conditions, options[:find_options][:conditions])
        end
        collection = reflection.klass.find(:all, options[:find_options])
        collection.map { |o| [pretty_format(o), o.id] }
      else
        boolean_collection(klass, column, options)
      end
      collection
   end

    def boolean_collection(klass, column, options)
      [['Yes', true], ['No', false]]
    end

    def filter_check_boxes_input(klass, method, options = {})
      input_name = (generate_association_input_name(klass, method).to_s + "_in").to_sym
      collection = find_collection_for_column(klass, method, options)
      selected_values = params[input_name] || []
      checkboxes = content_tag :div, :class => "check_boxes_wrapper" do
        collection.map do |c|
          label = c.is_a?(Array) ? c.first : c
          value = c.is_a?(Array) ? c.last : c
          "<label><input type=\"checkbox\" name=\"#{input_name}[]\" value=\"#{value}\" #{selected_values.include?(value) ? "checked" : ""}/> #{label}</label>"
        end.join("\n").html_safe
      end

      [ label(input_name, options[:title] || method.to_s.titlecase),
        checkboxes
      ].join("\n").html_safe
    end

    # Returns the default filter type for a given attribute
    def default_filter_type(klass, method)
      if column = column_for(klass, method)
        case column.type
        when :date, :datetime
          return :date_range
        when :string, :text
          return :string
        when :integer
          return :select if reflection_for(klass, method.to_s.gsub('_id','').to_sym)
          return :numeric
        when :float, :decimal
          return :numeric
        end
      end

      if reflection = reflection_for(klass, method)
        return :select if reflection.macro == :belongs_to && !reflection.options[:polymorphic]
      end
    end

    # Returns the column for an attribute on the object being searched
    # if it exists. Otherwise returns nil
    def column_for(klass, method)
      klass.columns_hash[method.to_s] if klass.respond_to?(:columns_hash)
    end

    # Returns the association reflection for the method if it exists
    def reflection_for(klass, method)
      klass.reflect_on_association(method) if klass.respond_to?(:reflect_on_association)
    end
  end
end
