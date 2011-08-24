module SimpleAdmin
  module FormHelper
    def form_fields(form, attributes)
      attributes.map do |col|
        options = (col.options || {}).dup
        expand_block_options!(options)

        case col.kind
        when :attribute
          form.input col.attribute, options
        when :content
          instance_exec(@resource, &col.data)
        when :fieldset
          content_tag :fieldset, options do
            content_tag :legend do
              options[:legend]
            end unless options[:legend].blank
            form_fields(form, col.attributes)
          end
        else
          content_tag :div, options do
            form_fields(form, col.attributes)
          end
        end
      end.join.html_safe
    end

    def form_field(form, col)
      options = (col.options || {}).dup
      expand_block_options!(options)
      form.input col.attribute, options
    end
  end
end
