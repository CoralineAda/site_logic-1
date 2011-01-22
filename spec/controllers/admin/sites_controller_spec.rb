require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do
  render_views

  before :all do
    Site.destroy_all
    @site_1 = Site.make
    @site_2 = Site.make
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Site.first.id
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Site.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Site.any_instance.stubs(:valid?).returns(true)
    Site.any_instance.stubs(:activate!).returns(true)
    post :create, :site => {:state => nil}
    response.should redirect_to(admin_site_url(assigns[:site]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Site.first.id
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Site.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Site.first.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Site.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Site.first.id, :site => {:state => nil}
    response.should redirect_to(admin_site_url(assigns[:site]))
  end

  it "destroy action should destroy model and redirect to index action" do
    site = Site.first
    delete :destroy, :id => site.id
    response.should redirect_to(admin_sites_url)
    Site.where(:id => site.id).first.should be_nil
  end
end
