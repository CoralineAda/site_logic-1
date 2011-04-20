require File.dirname(__FILE__) + '/../spec_helper'

describe NavItem do

  it "should be valid with minimum values" do
    NavItem.new(
      :kind => 'Primary',
      :url  => '/foo/',
      :link_text => 'Foo',
      :link_title => 'Foo page'
    ).should be_valid
  end

  describe 'organizes nav items into hierarchies' do

    before :all do
      Site.destroy_all
      @site = Site.make
      @parent = @site.nav_items.create(NavItem.make_unsaved.attributes)
      @child_1 = @site.nav_items.create(NavItem.make_unsaved.attributes.merge(:parent_id => @parent.id.to_s))
      @child_2 = @site.nav_items.create(NavItem.make_unsaved.attributes.merge(:parent_id => @parent.id.to_s))
    end

    it 'returns its children' do
      @parent.children.to_a.should have(2).items
    end

    it 'returns its parent nav itm' do
      @child_1.parent.should == @parent
    end

    it 'returns its siblings' do
      @child_1.siblings.should include @child_2
      @child_1.siblings.should have(1).item
    end

    it 'detects roots' do
      @parent.root?.should be_true
      @child_1.root?.should be_false
    end

    it 'detects sub nav items' do
      @parent.sub_nav_item?.should be_false
      @child_1.sub_nav_item?.should be_true
    end

  end

  describe 'url obfuscation' do

    before :all do
      @obf = NavItem.make_unsaved(:url => 'foo', :obfuscate => true)
      @clear = NavItem.make_unsaved(:url => 'bar')
    end

    it 'returns the URL for an unobfuscated nav item' do
      @clear.url.should == 'bar'
    end

    it 'returns the URL for an obfuscated nav item' do
      @obf.url.should_not == 'foo'
    end

    it 'obfuscates a URL using ROT13 encoding' do
      @obf.encoded_url.should == 'sbb'
    end

    it 'returns its undecoded URL' do
      @obf.decoded_url.should == 'foo'
    end

  end


end
