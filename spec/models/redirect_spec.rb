require File.dirname(__FILE__) + '/../spec_helper'

describe SiteLogic::Redirect do
  it "should be valid" do
    SiteLogic::Redirect.new.should be_valid
  end
end
