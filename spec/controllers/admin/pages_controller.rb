require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PagesController do
  render_views

  before :all do
    Site.destroy_all
    @site = Site.make
    @page = @site.pages.create(:page_title => 'Vampire Bunnies', :desired_slug => 'bunnicula', :content => 'Scary monsters.')
  end

  it "show action should render show template" do
    get :show, :site_id => @site.id, :id => @page.id
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new, :site_id => @site.id
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Page.any_instance.stubs(:valid?).returns(false)
    post :create, :site_id => @site.id
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Page.any_instance.stubs(:valid?).returns(true)
    post :create, :site_id => @site.id
    response.should redirect_to(admin_page_url(assigns[:page]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => @page, :site_id => @site.id
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Page.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @page, :site_id => @site.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Page.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @page, :site_id => @site.id
    response.should redirect_to(admin_page_url(assigns[:page]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    page = Page.first
    delete :destroy, :id => page.id, :site_id => @site.id
    response.should redirect_to(admin_pages_url)
    Page.where(:id => page.id).first.should be_nil
  end
end