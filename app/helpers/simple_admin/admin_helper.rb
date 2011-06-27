module SimpleAdmin
  module AdminHelper
    include SimpleAdmin::TitleHelper
    include SimpleAdmin::HeaderHelper
    include SimpleAdmin::TableHelper
    include SimpleAdmin::DisplayHelper
    include SimpleAdmin::FilterHelper
    include SimpleAdmin::SidebarHelper
    include SimpleAdmin::PathHelper
    include SimpleAdmin::AssetsHelper
  end
end
