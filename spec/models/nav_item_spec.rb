require File.dirname(__FILE__) + '/../spec_helper'

describe NavItem do
  it "should be valid" do
    NavItem.new.should be_valid
  end
end
