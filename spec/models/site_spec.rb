require 'spec_helper'

describe Site do

  before :all do
    Site.destroy_all
    @site = Site.make
  end

  describe 'initialization' do

    it "should be invalid without required values" do
      Site.new.valid?.should be_false
    end

    it "should be valid with required values" do
      Site.new(
        :domain => 'www.idolhands.com',
        :name   => 'IHD'
      ).should be_valid
    end

    it 'defaults its state to Inactive' do
      Site.new.status.should == 'Inactive'
    end

  end

  describe 'lifecycle' do

    it 'activates a site, setting the activation date' do
      @site.activate!
      @site.active?.should be_true
      @site.inactive?.should be_false
      @site.activation_date.should_not be_nil
    end

    it 'deactivates a site, clearing the activation date' do
      @site.activate!
      @site.deactivate!
      @site.active?.should be_false
      @site.inactive?.should be_true
      @site.activation_date.should be_nil
    end

  end

  it 'finds layout files on the filesystem' do
    Site.layouts.include?('application').should be_true
    Site.layouts.count.should == 1
  end

end
