module SimpleAdmin
  module FormHelper
    def form_fields(form, attributes)
      attributes.map do |col|
        case col.kind
        when :attribute
          form.input col.attribute, (col.options || {}).dup
        when :content
          instance_exec(@resource, &col.data)
        when :fieldset
          content_tag :fieldset, col.options do
            content_tag :legend do
              col.options[:legend]
            end unless col.options[:legend].blank
            form_fields(form, col.attributes)
          end
        else
          content_tag :div, col.options do
            form_fields(form, col.attributes)
          end
        end
      end.join.html_safe
    end
  end
end
