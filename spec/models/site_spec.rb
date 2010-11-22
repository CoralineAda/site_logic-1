require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  
  before :all do
    Site.destroy_all
  end
  
  it "should be valid" do
    Site.new(
      :domain => 'www.idolhands.com',
      :name   => 'IHD'
    ).should be_valid
  end
  
end
