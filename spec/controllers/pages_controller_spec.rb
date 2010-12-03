require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  render_views

  it "show action should render show template" do
    get :show, :id => Page.first
    response.should render_template(:show)
  end
  
end
