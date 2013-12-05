module SimpleAdmin
  module SidebarHelper
    def sidebars
      content = "".html_safe
      @interface.sidebars_for(params[:action].to_sym).each do |sidebar|
        content << instance_eval(&sidebar[:data])
      end
      content
    end
  end
end
