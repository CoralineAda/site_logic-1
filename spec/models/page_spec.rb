require 'spec_helper'

describe Page do
  before :all do
    Site.destroy_all
    @site = Site.make
  end

  describe 'initialization' do
    it 'should be invalid without required values' do
      @site.pages.new.valid?.should be_false
    end

    it 'should be valid with required values' do
      page = @site.pages.new(
        :page_title   => 'Home',
        :content      => 'Welcome home.'
      )
      page.send :set_slug
      page.should be_valid
    end

    it 'should not allow duplicate slugs' do
      @site.pages.create(
        :page_title   => 'Foo',
        :slug         => 'foo',
        :content      => 'Welcome to foo.'
      )
      @site.pages.create(
        :page_title   => 'Bar',
        :content      => 'Welcome to bar.'
      ).should_not be_valid
    end

    it 'defaults its sitemap inclusion' do
      @site.pages.new.sitemap.should be_true
    end

    it 'defaults its state to Draft' do
      @site.pages.new.status.should == 'Draft'
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
        :content      => 'Random stuff.'
      )
      page.publish!
      page.unpublish!
      page.published?.should be_false
      page.draft?.should be_true
      page.publication_date.should be_nil
    end
  end

  describe '#strip_leading_slash' do
    context 'with leading slashes' do
      before do
        @page = Page.new :slug => '/leading-slash'
        @page.strip_leading_slash
      end

      subject { @page.slug }

      it { should == 'leading-slash' }
    end

    context 'with trailing slashes' do
      before do
        @page = Page.new :slug => 'trailing-slash/'
        @page.strip_leading_slash
      end

      subject { @page.slug }

      it { should == 'trailing-slash/' }
    end

    context 'with slashes in the middle' do
      before do
        @page = Page.new :slug => 'middle/slash'
        @page.strip_leading_slash
      end

      subject { @page.slug }

      it { should == 'middle/slash' }
    end
  end

  describe '#strip_trailing_slash' do
    context 'with leading slashes' do
      before do
        @page = Page.new :slug => '/leading-slash'
        @page.strip_trailing_slash
      end

      subject { @page.slug }

      it { should == '/leading-slash' }
    end

    context 'with trailing slashes' do
      before do
        @page = Page.new :slug => 'trailing-slash/'
        @page.strip_trailing_slash
      end

      subject { @page.slug }

      it { should == 'trailing-slash' }
    end

    context 'with slashes in the middle' do
      before do
        @page = Page.new :slug => 'middle/slash'
        @page.strip_trailing_slash
      end

      subject { @page.slug }

      it { should == 'middle/slash' }
    end
  end

  describe 'normalizes its path' do
    it 'defaulting to root' do
      Page.new(:slug => nil).path.should == '/'
    end

    it 'handling no slashes' do
      Page.new(:slug => 'foo').path.should == '/foo'
    end

    it 'handling leading slash' do
      Page.new(:slug => '/foo').path.should == '/foo'
    end

    it 'handling trailing slash' do
      Page.new(:slug => 'foo/').path.should == '/foo/'
    end

    it 'handling all kindsa slash action' do
      Page.new(:slug => '/foo/').path.should == '/foo/'
    end
  end
end