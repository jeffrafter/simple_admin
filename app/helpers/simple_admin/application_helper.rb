module SimpleAdmin
  module ApplicationHelper
    def simple_admin_title
      "#{simple_admin_page_title} | #{simple_admin_site_title}"
    end

    def simple_admin_site_title
      SimpleAdmin::site_title
    end

    def simple_admin_page_title
      options = @interface.options_for(params[:action].to_sym) || {}
      case options[:title]
      when Proc
        options[:title].call(@resource)
      when Symbol
        if @resource
          @resource.send(optons[:title])
        else
          options[:title].to_s
        end
      when String
        options[:title]
      else
        if @resource && @resource.new_record?
          "New #{@interface.member.titleize}"
        elsif @resource
          "#{@interface.member.titleize}#{@resource.to_param.match(/\d+/) ? ' #' : ': '}#{@resource.to_param}"
        else
          @interface.collection.titlecase
        end
      end
    end

    def simple_admin_tabs
      content_tag :ul, :id => 'tabs' do
        SimpleAdmin.registered.collect do |interface|
          content_tag :li, :id => interface.collection, :class => "#{'current' if @interface == interface}" do
            link_to interface.collection.titlecase, send("simple_admin_#{interface.collection}_path".to_sym)
          end
        end.join.html_safe
      end
    end

    def simple_admin_utility_nav
      content_tag :p, :id => 'utility_nav' do
        if send(SimpleAdmin.current_user_method)
          content = content_tag(:span, send(SimpleAdmin.current_user_name_method), :class => "current_user")
          content << link_to("Logout", Rails.application.routes.url_helpers.logout_path) if Rails.application.routes.url_helpers.respond_to?(:logout_path)
          content
        end
      end
    end

    def simple_admin_breadcrumbs
      content_tag :span, :class => 'breadcrumb' do
        SimpleAdmin::Breadcrumbs.parse(request.fullpath, params[:action]).collect do |crumb|
          link_to(crumb.first, crumb.last) +
          content_tag(:span, ' / ', :class => 'breadcrumb_sep')
        end.join.html_safe
      end
    end

    def simple_admin_action_items
      content_tag :div, :class => "action_items" do
        content = ""
        # If we are currently showing, then check for edit and destroy action items
        if params[:action].to_sym == :show
          if controller.action_methods.include?('edit')
            content << link_to("Edit #{@interface.member.titlecase}",
              send("edit_simple_admin_#{@interface.member}_path", @object))
          end
          content << "&nbsp;"
          if controller.action_methods.include?("destroy")
            content << link_to("Delete #{@interface.member.titlecase}",
              send("simple_admin_#{@interface.member}_path", @object),
              :method => :delete, :confirm => "Are you sure you want to delete this?")
          end
        end
        # If we are not showing an item or creating a new one, then check for new action items
        unless [:new, :show].include?(params[:action].to_sym)
          if controller.action_methods.include?('new')
            content << link_to("New #{@interface.member.titlecase}",
              send("new_simple_admin_#{@interface.member}_path"))
          end
        end
        content.html_safe
      end
    end

    def simple_admin_sortable_header_classes_for(col)
      current_sort = simple_admin_current_sort
      classes = []
      classes << "sortable" if col.sortable
      classes << "sorted-#{current_sort[1]}" if current_sort[0] == col.sort_key
      classes.join(' ')
    end

    # Returns an array for the current sort order
    #   current_sort[0] #=> sort_key
    #   current_sort[1] #=> asc | desc
    def simple_admin_current_sort
      if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        [$1,$2]
      else
        []
      end
    end

    # Returns the order to use for a given sort key
    #
    # Default is to use 'desc'. If the current sort key is
    # 'desc' it will return 'asc'
    def simple_admin_order_for_sort_key(sort_key)
      current_key, current_order = simple_admin_current_sort
      return 'desc' unless current_key == sort_key
      current_order == 'desc' ? 'asc' : 'desc'
    end

    # Return a pretty string for any object
    # Date Time are formatted via #localize with :format => :long
    # ActiveRecord objects are formatted via #auto_link
    # We attempt to #display_name of any other objects
    def simple_admin_pretty_format(object)
      case object
      when String
        object
      when Date, Time
        localize(object, :format => :long)
      else
        (object.respond_to?(:display_name) && object.send(:display_name)) ||
        (object.respond_to?(:full_name) && object.send(:full_name)) ||
        (object.respond_to?(:name) && object.send(:name)) ||
        (object.respond_to?(:username) && object.send(:username)) ||
        (object.respond_to?(:login) && object.send(:login)) ||
        (object.respond_to?(:title) && object.send(:title)) ||
        (object.respond_to?(:email) && object.send(:email)) ||
        (object.respond_to?(:to_s) && object.send(:to_s)) ||
        "#{object}"
      end
    end

    def simple_admin_resource_actions(object)
      links = link_to "View",  send("simple_admin_#{@interface.member}_path", object), :class => "member_link view_link"
      links += link_to "Edit", send("edit_simple_admin_#{@interface.member}_path", object), :class => "member_link edit_link"
      links += link_to "Delete", send("simple_admin_#{@interface.member}_path", object), :method => :delete, :confirm => "Are you sure you want to delete this?", :class => "member_link delete_link"
      links
    end

    def filter_for(method, klass, options={})
      options ||= {}
      options[:as] ||= default_filter_type(klass, method)
      return "" unless options[:as]
      field_type = options.delete(:as)
      content_tag :div, :class => "filter_form_field filter_#{field_type}" do
        send("filter_#{field_type}_input", klass, method, options)
      end
    end

    def filter_string_input(klass, method, options = {})
      field_name = "#{method}_contains"

      [ label(field_name, "Search #{method.to_s.titlecase}"),
        text_field_tag(field_name, params[field_name] || '')
      ].join("\n").html_safe
    end

    def filter_date_range_input(klass, method, options = {})
      gt_field_name = "#{method}_gte"
      lt_field_name = "#{method}_lte"

      [ label(gt_field_name, method.to_s.titlecase),
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

      [ label_tag(method), filter_select, " ", filter_input].join("\n").html_safe
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
      input_name = (input_name + "_eq").to_sym
      collection = find_collection_for_column(klass, association_name, options)
      [ label(input_name, method.to_s.titlecase),
        select_tag(input_name, options_for_select(collection, params[input_name]), :include_blank => options[:include_blank] || 'Any')
      ].join("\n").html_safe
    end

    def find_collection_for_column(klass, column, options) #:nodoc:
      collection = if options[:collection]
        options.delete(:collection)
      elsif reflection = reflection_for(klass, column)
        options[:find_options] ||= {}
        if conditions = reflection.options[:conditions]
          options[:find_options][:conditions] = reflection.klass.merge_conditions(conditions, options[:find_options][:conditions])
        end
        reflection.klass.find(:all, options[:find_options])
      else
        boolean_collection(klass, column, options)
      end
      collection = collection.to_a if collection.is_a?(Hash)
      collection.map { |o| [simple_admin_pretty_format(o), o.id] }
    end

    def boolean_collection(klass, column, options)
      [['Yes', true], ['No', false]]
    end

    def filter_check_boxes_input(klass, method, options = {})
      input_name = (generate_association_input_name(method).to_s + "_in").to_sym
      collection = find_collection_for_column(method, options)
      selected_values = klass.send(input_name) || []
      checkboxes = template.content_tag :div, :class => "check_boxes_wrapper" do
        collection.map do |c|
          label = c.is_a?(Array) ? c.first : c
          value = c.is_a?(Array) ? c.last : c
          "<label><input type=\"checkbox\" name=\"#{input_name}[]\" value=\"#{value}\" #{selected_values.include?(value) ? "checked" : ""}/> #{label}</label>"
        end.join("\n").html_safe
      end

      [ label(input_name, method.to_s.titlecase),
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

    def data_for(col)
      value = if col.data
        col.data.call(@resource, col)
      elsif col.attribute.to_s =~ /^([\w]+)_id$/ && @resource.respond_to?($1.to_sym)
        simple_admin_pretty_format(@resource.send($1))
      else
        simple_admin_pretty_format(@resource.send(col.attribute))
      end
      value ||= content_tag(:span, 'Empty', :class => 'empty')
    end

    def resource_path(res)
      if res.new_record?
        send("simple_admin_#{@interface.collection}_path")
      else
        send("simple_admin_#{@interface.member}_path", res)
      end
    end
  end
end
