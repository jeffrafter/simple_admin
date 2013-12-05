require 'spec_helper'

describe SimpleAdmin::Section do

  before :each do
    @interface = SimpleAdmin.register(:thing)
  end

  it "creates a default set of attributes" do
    SimpleAdmin::Section.any_instance.expects(:attributes)
    @section = SimpleAdmin::Section.new(@interface, :index)
  end

  it "creates a default set of filters for the index" do
    SimpleAdmin::Section.any_instance.expects(:filters)
    @section = SimpleAdmin::Section.new(@interface, :index)
  end

  it "does not create a default set of filters for non-index actions" do
    SimpleAdmin::Section.any_instance.expects(:filters).never
    @section = SimpleAdmin::Section.new(@interface, :form)
  end

  it "accepts a block" do
    SimpleAdmin::Section.any_instance.expects(:success)
    @section = SimpleAdmin::Section.new(@interface, :form) do
      success
    end
   end

  it "does not require a block" do
    @section = SimpleAdmin::Section.new(@interface, :form)
    @section.should_not be_nil
  end

  it "allows you to specify an attributes section" do
    @section = SimpleAdmin::Section.new(@interface, :form)
    @section.attributes(:only => [:name])
    @section.options[:attributes].attributes.map(&:attribute).should == [:name]
  end

  it "allows you to specify a filters section for index actions" do
    @section = SimpleAdmin::Section.new(@interface, :index)
    @section.filters(:only => [:name])
    @section.options[:filters].attributes.map(&:attribute).should == [:name]
  end

  it "does not allow you to specify a filters section for non-index actions" do
    @section = SimpleAdmin::Section.new(@interface, :form)
    expect {
      @section.filters(:only => [:name])
    }.to raise_error
   end

  it "allows you to specify sidebar sections" do
    SimpleAdmin::Section.expects(:success).times(2)
    @section = SimpleAdmin::Section.new(@interface, :index)
    @section.sidebar { SimpleAdmin::Section.success }
    @section.sidebar { SimpleAdmin::Section.success }
    @section.options[:sidebars].each{|s| s[:data].call}
  end

end
