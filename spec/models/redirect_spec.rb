require File.dirname(__FILE__) + '/../spec_helper'

describe Redirect do
  it "should be valid" do
    site = Site.make
    site.redirects.new(
      :source_url => 'foo',
      :destination_url => 'bar'
    ).should be_valid
  end
end
