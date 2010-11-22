require File.dirname(__FILE__) + '/../spec_helper'

describe Page do

  before :all do
    Site.destroy_all
    @site = Site.make
  end

  describe "initialization" do
  
    it "should be invalid without required values" do
      @site.pages.new.valid?.should be_false
    end
    
    it "should be valid with required values" do
      @site.pages.new(
        :page_title   => 'Home',
        :desired_slug => 'home',
        :content      => 'Welcome home.'
      ).should be_valid
    end
    
    it "should not allow duplicate slugs" do
      @site.pages.create(
        :page_title   => 'Foo',
        :slug         => 'foo',
        :content      => 'Welcome to foo.'
      )
      @site.pages.create(
        :page_title   => 'Bar',
        :desired_slug => 'foo',
        :content      => 'Welcome to bar.'
      ).should_not be_valid
    end
    
  end
  
  describe 'lifecycle' do

    it 'publishes a page, setting the publication date' do
      page = @site.pages.make
      page.publish!
      page.published?.should be_true
      page.draft?.should be_false
      page.publication_date.should_not be_nil
    end
    
#     it 'deactivates a site, clearing the activation date' do
#       @site.activate!
#       @site.deactivate!
#       @site.active?.should be_false
#       @site.inactive?.should be_true
#       @site.activation_date.should be_nil
#     end
    
  end

end
