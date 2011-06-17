module SimpleAdmin
  module PathHelper
    def resource_path(res)
      if res.new_record?
        send("simple_admin_#{@interface.collection}_path")
      else
        send("simple_admin_#{@interface.member}_path", res)
      end
    end
  end
end

