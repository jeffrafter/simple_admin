require 'spec_helper'

describe SimpleAdmin::Filters do
  before :each do
    @interface = SimpleAdmin.register(:thing)
    @section = @interface.send(:section, :index)
    @filters = SimpleAdmin::Filters.new(@interface, @section)
  end

  it "allows new filter definitions and treats them like attributes" do
    @filters.clear
    @filters.filter(:name)
    @filters.attributes.map(&:attribute).should == [:name]
  end
end

