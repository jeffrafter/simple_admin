SimpleAdmin::Engine.routes.draw do
  root :to => "admin#index", :interface => SimpleAdmin::registered.first.try(:collection)
  SimpleAdmin::registered.each do |interface|
    resources interface.collection,
              :controller => :admin,
              :as => "simple_admin_#{interface.collection}",
              :defaults => {:interface => interface.collection}
  end
end
