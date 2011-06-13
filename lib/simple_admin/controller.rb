module SimpleAdmin
  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :simple_admin_find_interface
    end

    module InstanceMethods
      def simple_admin_find_interface
        SimpleAdmin.registered.each do |interface|
          @interface = interface if interface.collection == params[:interface]
        end
      end
    end
  end
end

::ActionController::Base.send :include, SimpleAdmin::Controller
