module SimpleAdmin
  module TitleHelper
    def title
      page_title ? "#{page_title} | #{site_title}" : site_title
    end

    def site_title
      SimpleAdmin::site_title
    end

    def page_title
      return nil unless @interface

      options = @interface.options_for(params[:action].to_sym)
      case options[:title]
      when Proc
        instance_exec(@resource, &options[:title])
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
  end
end
