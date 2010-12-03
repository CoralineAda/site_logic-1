class Admin::PagesController < ApplicationController

  before_filter :scope_site
  before_filter :scope_page, :only => [:edit, :update, :destroy, :show]
  
  def index
    params[:labels] = {
      :humanize_path => 'URL',
      :state         => 'Status',
      :updated_at    => 'Last Modified'
    }
    
    @pages = @site.pages.all
  end
  
  def show
  end
  
  def new
    @page = @site.pages.new
  end
  
  def create
    if params[:commit] == 'Preview'
      render :action => 'preview', :layout => @page.site.layout
    else
      @page = @site.pages.create(params[:page])
      if @page.valid?
        @page.publish! if params[:page][:state] == 'Published'
        flash[:notice] = "Successfully created the page."
        redirect_to admin_site_pages_path(@site)
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
  end
  
  def update
    if params[:commit] == 'Preview'
      render :action => 'preview', :layout => @page.site.layout
    else
      if @page.update_attributes(params[:page])
        @page.publish! if params[:page][:state] == 'Published'
        @page.unpublish! if params[:page][:state] == 'Draft'
        flash[:notice] = "Successfully updated the page."
        redirect_to admin_site_pages_path(@site)
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    @page.destroy
    flash[:notice] = "Successfully destroyed the page."
    redirect_to admin_site_pages_path(@site)
  end

  def preview
    render :layout => @page.site.layout
  end
  
  private
  
  def scope_site
    @site = Site.find(params[:site_id])
  end
  
  def scope_page
    @page = @site.pages.find(params[:id])
  end
  
end