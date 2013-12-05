require 'spec_helper'

describe SimpleAdmin::Attributes do

  before :each do
    @interface = SimpleAdmin.register(:thing)
    @section = @interface.send(:section, :index)
    @attributes = SimpleAdmin::Attributes.new(@interface, @section)
  end

  describe "initialize" do
    it "defaults the attributes on initialize" do
      @attributes.attributes.should_not be_blank
    end

    it "executes the block if submitted" do
      @attributes = SimpleAdmin::Attributes.new(@interface, @section) do
        clear
      end
      @attributes.attributes.should be_blank
     end
  end

  describe "clear" do
    it "clears the list of attributes" do
      @attributes.clear
      @attributes.attributes.should be_blank
    end
  end

  describe "defaults" do
    it "creates a default set of attributes based on the columns" do
      @attributes.attributes.map(&:attribute).should == [:id, :name, :happy, :age, :place_id, :created_at, :updated_at]
    end

    it "rejects attributes that are listed in the except option" do
      @attributes = SimpleAdmin::Attributes.new(@interface, @section, :except => [:created_at, :updated_at])
      @attributes.attributes.map(&:attribute).should == [:id, :name, :happy, :age, :place_id]
    end

    it "only includes attributes that are listed in the only option" do
      @attributes = SimpleAdmin::Attributes.new(@interface, @section, :only => [:name, :happy, :age])
      @attributes.attributes.map(&:attribute).should == [:name, :happy, :age]
    end

    it "only includes content attributes if the attributes are on a form section" do
      @section = @interface.send(:section, :form)
      @attributes = SimpleAdmin::Attributes.new(@interface, @section)
      @attributes.attributes.map(&:attribute).should_not include(:id)
    end

    it "excludes skipped attributes if the attributes are on a form section" do
      @section = @interface.send(:section, :form)
      @attributes = SimpleAdmin::Attributes.new(@interface, @section)
      @attributes.attributes.map(&:attribute).should_not include(:created_at)
    end
  end

  describe "attribute" do
    before :each do
      @attributes.clear
    end

    it "adds an attribute" do
      @attributes.attribute(:name)
      @attributes.attributes.map(&:attribute).should == [:name]
    end

    it "sets the title" do
      @attributes.attribute(:name)
      @attributes.attribute(:age, :title => "Awesome age!")
      @attributes.attributes.map(&:title).should == ["Name", "Awesome age!"]
    end

    it "defaults to being sortable" do
      @attributes.attribute(:name)
      @attributes.attributes.map(&:sortable).should == [true]
    end

    it "allows you to mark an attribute as unsortable" do
      @attributes.attribute(:age, :sortable => false)
      @attributes.attribute(:happy, :sortable => true)
      @attributes.attributes.map(&:sortable).should == [false, true]
    end

    it "allows an alternate sort key" do
      @attributes.attribute(:name)
      @attributes.attribute(:happy, :sort_key => :name)
      @attributes.attributes.map(&:sort_key).should == ["name", "name"]
    end

    it "accepts a block" do
      @attributes.attribute(:name) do |object|
        object
      end
      @attributes.attributes.last.data.call(true).should == true
    end

    it "overrides previously defined attributes" do
      @attributes.attribute(:name)
      @attributes.attribute(:name, :title => "Your Name Here")
      @attributes.attributes.map(&:title).should == ["Your Name Here"]
    end
  end

  describe "section" do
    it "creates a section" do
      @attributes.clear
      @attributes.section :class => 'bang'
      @attributes.attributes.map {|att|
        att.attributes.should == []
        att.kind.should == :section
        att.options.should == {:class => 'bang'}
      }
    end

    it "contains attributes" do
      @attributes.clear
      @attributes.section :class => 'bang' do
        attribute :name, :title => "Your Name Here"
      end
      @attributes.attributes.map {|att|
        att.attributes.map(&:title).should == ["Your Name Here"]
      }
    end

    it "contains sections" do
      @attributes.clear
      @attributes.section :class => 'bang' do
        section :class => 'bleep' do
          attribute :name, :title => "Your Name Here"
        end
      end
      @attributes.attributes.map {|att|
        att.attributes.map {|sec|
          sec.attributes.map(&:title).should == ["Your Name Here"]
        }
      }
    end

  end

  describe "content" do
    it "creates content" do
      SimpleAdmin::Attributes.expects(:fail).never
      @attributes.clear
      @attributes.content(:class => 'bang') do
        SimpleAdmin::Attributes.fail
      end
      @attributes.attributes.map {|att|
        att.data.should_not be_nil
        att.kind.should == :content
        att.options.should == {:class => 'bang'}
      }
    end
  end
end

