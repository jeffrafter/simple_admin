require 'spec_helper'

describe SimpleAdmin::Builder do
  before :each do
    @interface = SimpleAdmin.register(:thing)
    @builder = SimpleAdmin::Builder.new(@interface)
  end

  it "does not require a block when initializing" do
    @builder.should_not be_nil
  end

  it "executes the block when initializing" do
    SimpleAdmin::Builder.any_instance.expects(:success)
    SimpleAdmin::Builder.new(@interface) do
      success
    end
  end

  describe "sections" do
    before :each do
      @options = {}
    end

    it "creates a section" do
      SimpleAdmin::Section.expects(:new)
      @section = @builder.section(:index)
      @interface.sections[:index].should == @section
    end

    it "creates an index" do
      @builder.expects(:section).with(:index, @options).returns(true)
      @builder.index(@options)
    end

    it "creates a show" do
      @builder.expects(:section).with(:show, @options).returns(true)
      @builder.show(@options)
    end

    it "creates a form" do
      @builder.expects(:section).with(:form, @options).returns(true)
      @builder.form(@options)
    end

  end

  it "creates a before block" do
    SimpleAdmin::Builder.expects(:success)
    @builder.before do
      SimpleAdmin::Builder.success
    end
    @interface.before.each{|before| before[:data].call}
  end

end

