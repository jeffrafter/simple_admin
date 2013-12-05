require 'spec_helper'

describe SimpleAdmin::Breadcrumbs do
  it "parses the path" do
    SimpleAdmin::Breadcrumbs.parse("/admin/things", "index").should == [["Admin", "/admin"]]
  end

  it "includes the last step if creating" do
    SimpleAdmin::Breadcrumbs.parse("/admin/things", "create").should == [["Admin", "/admin"], ["Things", "/admin/things"]]
  end

  it "finds the object and uses the display name" do
    @thing = Factory(:thing)
    Thing.any_instance.expects(:display_name).returns("A Thing!")
    SimpleAdmin::Breadcrumbs.parse("/things/#{@thing.id}", "create").should == [["Things", "/things"],["A Thing!", "/things/#{@thing.id}"]]
  end
end

