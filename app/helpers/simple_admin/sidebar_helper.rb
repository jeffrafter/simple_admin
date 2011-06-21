module SimpleAdmin
  module SidebarHelper
    def sidebars
      @interface.sidebars_for(:index).each do |sidebar|
        instance_exec(sidebar, &sidebar[:data])
      end
    end
  end
end
