require 'spec_helper'

class ThingWithCrazyClassName < Thing; end

describe SimpleAdmin::Interface do
  it "accepts a constant as the resource" do
    @interface = SimpleAdmin.register(Thing)
    @interface.constant.should == Thing
  end

  it "accepts a crazy constant as the resource" do
    @interface = SimpleAdmin.register(ThingWithCrazyClassName)
    @interface.constant.should == ThingWithCrazyClassName
    @interface.member.should == "thing_with_crazy_class_name"
  end

  it "accepts a symbol as the resource" do
    @interface = SimpleAdmin.register(:thing)
    @interface.constant.should == Thing
  end

  it "accepts a string as the resource" do
    @interface = SimpleAdmin.register("thing")
    @interface.constant.should == Thing
  end

  it "accepts a plural as the resource" do
    @interface = SimpleAdmin.register(:things)
    @interface.constant.should == Thing
  end

  it "has a collection" do
    @interface = SimpleAdmin.register(:thing)
    @interface.collection.should == "things"
  end

  it "has a member" do
    @interface = SimpleAdmin.register(:things)
    @interface.member.should == "thing"
  end

  it "does not require a block" do
    @interface = SimpleAdmin.register(:things)
    @interface.should_not be_nil
  end

  it "doesn't execute a block using a builder when initialized" do
    SimpleAdmin::Builder.any_instance.expects(:success).never
    @interface = SimpleAdmin.register(:things) do
      success
    end
  end

  it "executes a block using a builder if a section is requested" do
    SimpleAdmin::Builder.any_instance.expects(:success)
    @interface = SimpleAdmin.register(:things) do
      success
    end
    @interface.send(:section, :custom)
  end

  it "retrieves the attributes for a section" do
    @interface = SimpleAdmin.register(:things)
    @interface.attributes_for(:form).map(&:attribute).should == [:name, :happy, :age, :place]
  end

  it "retrieves the filters for a section" do
    @interface = SimpleAdmin.register(:things)
    @interface.filters_for(:index).map(&:attribute).should == [:id, :name, :happy, :age, :place_id, :created_at, :updated_at]
  end

  it "retrieves the sidebars for a section" do
    SimpleAdmin.expects(:success)
    @interface = SimpleAdmin.register(:things) do
      index do
        sidebar do
          SimpleAdmin.success
        end
      end
    end
    @interface.sidebars_for(:index).each{|sidebar| sidebar[:data].call}
  end

  it "retrieves or defaults a section" do
    @interface = SimpleAdmin.register(:things) do
      index :title => 'All of the things'
    end
    # Testing section method by proxy
    @interface.options_for(:index)[:title].should == "All of the things"
    @interface.options_for(:form)[:title].should be_nil
  end

  it "defaults to allowing all actions" do
    @interface = SimpleAdmin.register(:things)
    @interface.actions.should == [:index, :show, :edit, :new, :destroy, :create, :update]
  end

  it "allows overrides to the default set of actions" do
    @interface = SimpleAdmin.register(:things, :actions => [:index, :show])
    @interface.actions.should == [:index, :show]
  end

  it "excludes actions from the default set of actions" do
    @interface = SimpleAdmin.register(:things, :except => [:destroy])
    @interface.actions.should == [:index, :show, :edit, :new, :create, :update]
  end

  it "limits the allowable actions" do
    @interface = SimpleAdmin.register(:things, :only => [:index])
    @interface.actions.should == [:index]
  end

end

