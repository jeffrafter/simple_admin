module SimpleAdmin
  module AdminHelper
    def expand_block_options!(options)
      options.each do |key, val|
        case val
        when Proc
          options[key] = instance_exec(@resource, &val)
        else
          options[key] = val
        end
      end
    end

    include SimpleAdmin::TitleHelper
    include SimpleAdmin::HeaderHelper
    include SimpleAdmin::TableHelper
    include SimpleAdmin::DisplayHelper
    include SimpleAdmin::FilterHelper
    include SimpleAdmin::SidebarHelper
    include SimpleAdmin::PathHelper
    include SimpleAdmin::AssetsHelper
    include SimpleAdmin::FormHelper
  end
end
