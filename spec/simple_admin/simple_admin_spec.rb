require 'spec_helper'

describe SimpleAdmin do
  describe "config" do
    it "has configurable attributes" do
      [:require_user_method,
       :current_user_method,
       :current_user_name_method,
       :site_title,
       :default_per_page,
       :form_for_helper,
       :stylesheet,
       :javascript].each do |method|
        SimpleAdmin.should respond_to("#{method}=".to_sym)
      end
    end

    it "can be setup" do
      SimpleAdmin.expects(:success)
      SimpleAdmin.setup do |config|
        config.success
      end
    end
  end

  it "has a default site title" do
    SimpleAdmin.site_title.should == "Sample"
    SimpleAdmin.setup {|config| config.site_title = "Yay!"}
    SimpleAdmin.site_title.should == "Yay!"
  end

  it "has a default number of items per page" do
    SimpleAdmin.default_per_page.should == 25
    SimpleAdmin.setup {|config| config.default_per_page = 50}
    SimpleAdmin.default_per_page.should == 50
  end

  it "has a default form helper" do
    SimpleAdmin.form_for_helper.should == :semantic_form_for
    SimpleAdmin.setup {|config| config.form_for_helper = :simple_form_for }
    SimpleAdmin.form_for_helper.should == :simple_form_for
  end

  it "has a default stylesheet" do
    SimpleAdmin.stylesheet.should == "/stylesheets/simple_admin/active_admin.css"
    SimpleAdmin.setup {|config| config.stylesheet = "nyan-cat.css"}
    SimpleAdmin.stylesheet.should == "nyan-cat.css"
  end

  it "has a default script" do
    SimpleAdmin.javascript.should ==  "/javascripts/simple_admin/active_admin.js"
    SimpleAdmin.setup {|config| config.javascript = "nyan-cat.js"}
    SimpleAdmin.javascript.should == "nyan-cat.js"
  end

  describe "registering" do
    before :each do
      SimpleAdmin.registered
      SimpleAdmin.send(:class_variable_set, "@@registered", [])
    end

    it "can register an interface" do
      SimpleAdmin::Interface.expects(:new).returns(@interface)
      SimpleAdmin.register(:new_thing)
      SimpleAdmin.registered.should == [@interface]
    end
  end
end
