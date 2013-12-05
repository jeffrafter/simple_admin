require 'spec_helper'

describe SimpleAdmin::Engine do
  it "isolates the namespace for the engine" do
    SimpleAdmin::Engine.routes.default_scope.should == {:module => "simple_admin"}
    SimpleAdmin::Engine.isolated.should == true
  end
end

