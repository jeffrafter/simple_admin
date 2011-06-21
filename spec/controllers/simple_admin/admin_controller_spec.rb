require 'spec_helper'

describe SimpleAdmin::AdminController do
  render_views

  before :each do
    @thing = Factory(:thing)
  end

  describe "index" do
    it "should render the template" do
      get :index, :interface => "things"
    end

    it "should render the sidebars" do
      SimpleAdmin.expects(:success)
      @block = Proc.new {|sidebar| SimpleAdmin.success if sidebar[:title] == 'Awes!' }
      @sidebar = {:title => 'Awes!', :data => @block}
      SimpleAdmin::Interface.any_instance.expects(:sidebars_for).with(:index).returns([@sidebar])
      get :index, :interface => "things"
    end

    it "should render a csv" do
      get :index, :interface => "things", :format => "csv"
    end
  end

  describe "new" do
    it "should render the template" do
      get :new, :interface => "things"
    end
  end

  describe "show" do
    it "should render the template" do
      get :show, :id => @thing.id, :interface => "things"
    end
  end

  describe "edit" do
    it "should render the template" do
      get :edit, :id => @thing.id, :interface => "things"
    end
  end

  describe "create" do
    before :each do
      @params = {:interface => "things", :thing => Factory.attributes_for(:thing)}
    end

    it "should create a new thing" do
      expect {
        post :create, @params
      }.to change(Thing, :count)

      Thing.last.name.should == @params[:thing][:name]
    end

    it "should redirect to the collection page" do
      post :create, @params

      response.should be_redirect
    end
  end

  describe "update" do
    before :each do
      @params = {:id => @thing.id, :interface => "things", :thing => Factory.attributes_for(:thing)}
    end

    it "should update a thing" do
      expect {
        post :update, @params
      }.to_not change(Thing, :count)

      @thing.reload
      @thing.name.should == @params[:thing][:name]
    end

    it "should redirect to the collection page" do
      post :update, @params

      response.should be_redirect
    end
  end

  describe "destroy" do
    it "should destroy a thing" do
      expect {
        post :destroy, :id => @thing.id, :interface => "things"
      }.to change(Thing, :count)
    end
  end

end
