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

  describe 'publishing lifecycle' do

    it 'defaults a new page to draft status' do
      page = @site.pages.new
      page.draft?.should be_true
    end

    it 'publishes a page, setting the publication date' do
      page = @site.pages.create(
        :page_title   => 'Stiff',
        :desired_slug => 'corpse',
        :content      => 'Dead stuff.'
      )
      page.publish!
      page.published?.should be_true
      page.draft?.should be_false
      page.publication_date.should_not be_nil
    end

    it 'unpublishes a page, clearing the publication date' do
      page = @site.pages.create(
        :page_title   => 'Stuff',
        :desired_slug => 'detritus',
        :content      => 'Random stuff.'
      )
      page.publish!
      page.unpublish!
      page.published?.should be_false
      page.draft?.should be_true
      page.publication_date.should be_nil
    end

  end

  describe 'slug' do

    it 'is generated based on the desired_slug' do
      page = @site.pages.create(
        :page_title   => 'Snakes',
        :desired_slug => 'snakes and stuff',
        :content      => 'Random stuff.'
      )
      page.slug.should == 'snakes-and-stuff'
    end

    it 'truncates extra hyphens' do
      page = @site.pages.create(
        :page_title   => 'Spiders',
        :desired_slug => 'spiders!! and stuff',
        :content      => 'Random stuff.'
      )
      page.slug.should == 'spiders-and-stuff'
    end

    it 'truncates trailing hyphens' do
      page = @site.pages.create(
        :page_title   => 'Sinews',
        :desired_slug => 'sinews? really?',
        :content      => 'Random stuff.'
      )
      page.slug.should == 'sinews-really'
    end

  end

end
