require File.dirname(__FILE__) + '/../spec_helper'

describe Redirect do
  it "should be valid" do
    Redirect.new.should be_valid
  end
end
