module SimpleAdmin
  module HeaderHelper
    def tabs
      content_tag :ul, :id => 'tabs' do
        SimpleAdmin.registered.collect do |interface|
          content_tag :li, :id => interface.collection, :class => "#{'current' if @interface == interface}" do
            link_to interface.collection.titlecase, send("simple_admin_#{interface.collection}_path".to_sym)
          end
        end.join.html_safe
      end
    end

    def utility_nav
      content_tag :p, :id => 'utility_nav' do
        if SimpleAdmin.current_user_method && send(SimpleAdmin.current_user_method)
          content = "".html_safe
          content << content_tag(:span, send(SimpleAdmin.current_user_name_method), :class => "current_user") if SimpleAdmin.current_user_name_method
          content << link_to("Logout", Rails.application.routes.url_helpers.logout_path) if Rails.application.routes.url_helpers.respond_to?(:logout_path)
          content
        end
      end
    end

    def breadcrumbs
      content_tag :span, :class => 'breadcrumb' do
        SimpleAdmin::Breadcrumbs.parse(request.fullpath, params[:action]).collect do |crumb|
          link_to(crumb.first, crumb.last) +
          content_tag(:span, ' / ', :class => 'breadcrumb_sep')
        end.join.html_safe
      end
    end

    def action_items
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
  end
end
