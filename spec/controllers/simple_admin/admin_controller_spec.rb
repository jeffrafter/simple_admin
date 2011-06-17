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
  end

  describe "update" do
  end

  describe "destroy" do
  end

end
