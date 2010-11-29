class Admin::PagesController < ApplicationController

  before_filter :scope_site
  before_filter :scope_page, :only => [:edit, :update, :destroy, :show]
  
  def show
  end
  
  def new
    @page = @site.pages.new
  end
  
  def create
    @page = @site.pages.create(params[:page])
    if @page.valid?
      @page.publish! if params[:page][:state] == 'Published'
      flash[:notice] = "Successfully created the page."
      redirect_to admin_site_path(@site)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @page.update_attributes(params[:page])
      @page.publish! if params[:page][:state] == 'Published'
      @page.unpublish! if params[:page][:state] == 'Draft'
      flash[:notice] = "Successfully updated the page."
      redirect_to admin_site_path(@site)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @page.destroy
    flash[:notice] = "Successfully destroyed the page."
    redirect_to admin_site_path(@site)
  end

  private
  
  def scope_site
    @site = Site.find(params[:site_id])
  end
  
  def scope_page
    @page = @site.pages.find(params[:id])
  end
  
end