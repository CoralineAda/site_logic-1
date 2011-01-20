require File.dirname(__FILE__) + '/../spec_helper'

describe NavItem do
  it "should be valid" do
    NavItem.new(
      :kind => 'Primary',
      :url  => '/foo/',
      :link_text => 'Foo',
      :link_title => 'Foo page'
    ).should be_valid
  end
end
