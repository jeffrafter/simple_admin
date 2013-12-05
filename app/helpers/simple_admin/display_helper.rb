module SimpleAdmin
  module DisplayHelper

    # Return a pretty string for any object
    # Date Time are formatted via #localize with :format => :long
    # ActiveRecord objects are formatted via #auto_link
    # We attempt to #display_name of any other objects
    def pretty_format(object)
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

    def data_for(col)
      value = if col[:data]
        instance_exec(@resource, &col[:data])
      elsif col[:attribute].to_s =~ /^([\w]+)_id$/ && @resource.respond_to?($1.to_sym)
        pretty_format(@resource.send($1))
      else
        pretty_format(@resource.send(col[:attribute]))
      end
      value ||= content_tag(:span, 'Empty', :class => 'empty')
    end
  end
end
