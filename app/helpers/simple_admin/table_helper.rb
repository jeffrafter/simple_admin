module SimpleAdmin
  module TableHelper
    def sortable_header_classes_for(col)
      sort = current_sort
      classes = []
      classes << "sortable" if col[:sortable]
      classes << "sorted-#{sort[1]}" if sort[0] == col[:sort_key]
      classes.join(' ')
    end

    # Returns an array for the current sort order
    #   current_sort[0] #=> sort_key
    #   current_sort[1] #=> asc | desc
    def current_sort
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
    def order_for_sort_key(sort_key)
      current_key, current_order = current_sort
      return 'desc' unless current_key == sort_key
      current_order == 'desc' ? 'asc' : 'desc'
    end

    def resource_actions(object)
      links = ""
      links += link_to "View",  send("simple_admin_#{@interface.member}_path", object), :class => "member_link view_link" if @interface.actions.include?(:show)
      links += link_to "Edit", send("edit_simple_admin_#{@interface.member}_path", object), :class => "member_link edit_link" if @interface.actions.include?(:edit)
      links += link_to "Delete", send("simple_admin_#{@interface.member}_path", object), :method => :delete, :confirm => "Are you sure you want to delete this?", :class => "member_link delete_link" if @interface.actions.include?(:destroy)
      raw links
    end
  end
end
