require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UrlParser do

  before do
    @user = mock('user')
  end

  describe "deducing the requested action" do

    describe "parent_widget resources" do

      it "should recognize parent_widget index URLs" do
        expected = {
          :controller_name => "parent_widgets",
          :object_id       => nil,
          :action          => "index",
          :uri             => "/parent_widgets",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets")}.options_hash.should == expected
      end

      it "should recognize parent_widget edit URLs" do
        expected = {
          :controller_name => "parent_widgets",
          :object_id       => "1",
          :action          => "edit",
          :uri             => "/parent_widgets/1/edit",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/edit")}.options_hash.should == expected
      end

      it "should recognize new parent_widget URLs" do
        expected = {
          :controller_name => "parent_widgets",
          :object_id       => nil,
          :action          => "new",
          :uri             => "/parent_widgets/new",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/new")}.options_hash.should == expected
      end

      it "should recognize show parent_widget URLs" do
        expected = {
          :controller_name => "parent_widgets",
          :object_id       => "1",
          :action          => "show",
          :uri             => "/parent_widgets/1",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1")}.options_hash.should == expected
      end

    end

    describe "child resources" do

      it "should recognize child index URLs" do
        expected = {
          :controller_name => "child_widgets",
          :object_id       => nil,
          :action          => "index",
          :uri             => "/parent_widgets/1/child_widgets",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/child_widgets")}.options_hash.should == expected
      end

      it "should recognize child edit URLs" do
        expected = {
          :controller_name => "child_widgets",
          :object_id       => "1",
          :action          => "edit",
          :uri             => "/parent_widgets/1/child_widgets/1/edit",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/child_widgets/1/edit")}.options_hash.should == expected
      end

      it "should recognize new child URLs" do
        expected = {
          :controller_name => "child_widgets",
          :object_id       => nil,
          :action          => "new",
          :uri             => "/parent_widgets/1/child_widgets/new",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/child_widgets/new")}.options_hash.should == expected
      end

      it "should recognize show child URLs" do
        expected = {
          :controller_name => "child_widgets",
          :object_id       => "1",
          :action          => "show",
          :uri             => "/parent_widgets/1/child_widgets/1",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/child_widgets/1")}.options_hash.should == expected
      end

    end

    describe "singleton resources" do

      it "should recognize singleton_widget edit URLs" do
        expected = {
          :controller_name => "singleton_widget",
          :object_id       => nil,
          :action          => "edit",
          :uri             => "/parent_widgets/1/singleton_widget/edit",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/singleton_widget/edit")}.options_hash.should == expected
      end

      it "should recognize new singleton_widget URLs" do
        expected = {
          :controller_name => "singleton_widget",
          :object_id       => nil,
          :action          => "new",
          :uri             => "/parent_widgets/1/singleton_widget/new",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/singleton_widget/new")}.options_hash.should == expected
      end

      it "should recognize show singleton_widget URLs" do
        expected = {
          :controller_name => "singleton_widget",
          :object_id       => nil,
          :action          => "show",
          :uri             => "/parent_widgets/1/singleton_widget",
          :user            => @user
        }

        UrlParser.new(@user){url("/parent_widgets/1/singleton_widget")}.options_hash.should == expected
      end

    end

  end

end