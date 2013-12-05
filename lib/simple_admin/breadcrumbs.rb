module SimpleAdmin
  class Breadcrumbs
    # Returns an array of links to use in a breadcrumb
    def self.parse(path, action)
      parts = path.gsub(/^\//, '').split('/')
      parts.pop unless %w{ create update }.include?(action)
      crumbs = []
      parts.each_with_index do |part, index|
        name = ""
        if part =~ /^\d/ && parent = parts[index - 1]
          begin
            parent_class = parent.singularize.camelcase.constantize
            obj = parent_class.find(part.to_i)
            name = obj.display_name if obj.respond_to?(:display_name)
          rescue
          end
        end
        name = part.titlecase if name == ""
        crumbs << [name, "/" + parts[0..index].join('/')]
      end
      crumbs
    end
  end
end
