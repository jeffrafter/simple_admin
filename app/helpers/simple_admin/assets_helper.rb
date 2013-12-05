module SimpleAdmin
  module AssetsHelper
    def simple_admin_stylesheet_link_tag(*args)
      stylesheet_link_tag(*args)
    end

    def simple_admin_javascript_include_tag(*args)
      javascript_include_tag(*args)
    end
  end
end

