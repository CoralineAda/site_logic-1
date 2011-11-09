require 'spec_helper'

describe PagesController do
  before :all do
    Site.destroy_all
    @site = Site.make
    @page = @site.pages.create :page_title => 'Vampire Bunnies', :content => 'Scary monsters.', :state => 'published'
  end

  it 'show action should render show template' do
    get :show, :path => 'vampire-bunnies'
    response.should render_template(:show)
  end
end