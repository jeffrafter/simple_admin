# Unfortunately in Rails 4 the default route handling in url_for changed when no object
# is passed in. Now the route is matched on params[:controller] and params[:action] and
# finds the first matching route. Before it would use the current request.path. This
# replaces that behavior only for admin
module Kaminari
  module Helpers
    class Tag
      def page_url_for_with_admin(page)
        if @template.params[:controller] == "simple_admin/admin"
          @template.url_for "?"+@template.request.query_parameters.merge(@param_name => (page <= 1 ? nil : page)).to_query
        else
          page_url_for_without_admin(page)
        end
      end
      alias_method :page_url_for_without_admin, :page_url_for
      alias_method :page_url_for, :page_url_for_with_admin
    end
  end
end
