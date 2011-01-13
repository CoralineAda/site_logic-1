require File.dirname(__FILE__) + '/../../spec_helper'

describe SiteLogic::Admin::RedirectsController do
  render_views

  before :all do
    Site.destroy_all
    @site = Site.make
    @page = @site.pages.create(:page_title => 'Vampire Bunnies', :desired_slug => 'bunnicula', :content => 'Scary monsters.')
    @redirect = @site.redirects.create(:source_url => 'foo', :destination_url => 'bar')
  end

  it "index action should render index template" do
    get :index, :site_id => @site.id.to_s
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :site_id => @site.id.to_s, :id => @redirect.id.to_s
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new, :site_id => @site.id.to_s
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Redirect.any_instance.stubs(:valid?).returns(false)
    post :create, :site_id => @site.id.to_s
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Redirect.any_instance.stubs(:valid?).returns(true)
    post :create, :site_id => @site.id.to_s
    response.should redirect_to(admin_site_redirects_url(@site))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => @redirect.id, :site_id => @site.id.to_s
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Redirect.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @redirect.id, :site_id => @site.id.to_s
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Redirect.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @redirect.id, :site_id => @site.id.to_s
    response.should redirect_to(admin_site_redirects_url(@site))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    redirect = @redirect
    delete :destroy, :id => @redirect.id, :site_id => @site.id.to_s
    response.should redirect_to(admin_site_redirects_url(@site))
    @site.redirects.where(:id => redirect.id).should be_empty
  end
end
