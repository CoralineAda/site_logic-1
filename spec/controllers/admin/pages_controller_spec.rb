require 'spec_helper'

describe Admin::PagesController do
  before :all do
    Site.destroy_all
    @site = Site.make
    @page = @site.pages.create :page_title => 'Vampire Bunnies', :content => 'Scary monsters.'
  end

  it "show action should render show template" do
    get :show, :site_id => @site.id.to_s, :id => @page.id
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new, :site_id => @site.id.to_s
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Page.any_instance.stubs(:valid?).returns(false)
    post :create, :site_id => @site.id.to_s
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Page.any_instance.stubs(:valid?).returns(true)
    post :create, :site_id => @site.id, :page => {:page_title => 'Foo', :content => 'Bar'}
    response.should redirect_to(admin_site_pages_url(@site))
  end

  it "edit action should render edit template" do
    get :edit, :id => @page.id, :site_id => @site.id
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    put :update, :id => @page.id, :site_id => @site.id.to_s, :page => {:page_title => nil}
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => @page.id, :site_id => @site.id.to_s, :page => {:page_title => 'foozball'}
    response.should redirect_to(admin_site_pages_url(@site))
  end

  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => @page.id, :site_id => @site.id.to_s
    response.should redirect_to(admin_site_pages_url(@site))
    @site.pages.include?(@page.id).should be_false
  end

end
