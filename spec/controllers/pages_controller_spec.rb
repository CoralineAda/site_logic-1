require 'spec_helper'

describe PagesController do
  before :all do
    Site.destroy_all
    @site = Site.make
    @page = @site.pages.create(:page_title => 'Vampire Bunnies', :desired_slug => '/bunnicula/', :content => 'Scary monsters.', :state => 'published')
  end

  it "show action should render show template" do
    get :show, :page_slug => '/bunnicula/'
    response.should render_template(:show)
  end

end
