class Admin::PagesController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_site
  before_filter :scope_page, :only => [:edit, :update, :destroy, :show]
  
  def index
    params[:labels] = {
      :humanize_path => 'URL',
      :state         => 'Status',
      :updated_at    => 'Last Modified',
      :window_title  => 'Title Tag',
      :page_title    => 'Page Header'
    }
    params[:by] ||= 'humanize_path'; params[:dir] ||= 'ASC'
    @pages = @site.pages.sort{|a,b| a.send(params[:by]) <=> b.send(params[:by])}
    @pages.reverse! if params[:dir] == 'DESC'
  end
  
  def show
  end
  
  def new
    @page = @site.pages.new
  end
  
  def create
    if params[:commit] == 'Preview'
      @page = @site.pages.new(params[:page])
      render :action => 'preview', :layout => @site.layout
    else
      @page = @site.pages.create(params[:page])
      if @page.valid?
        @page.publish! if params[:page][:state] == 'Published'
        flash[:notice] = "Successfully created the page."
        if params[:page][:create_navigation_item]
          redirect_to new_admin_site_nav_item_path( 
            @site,
            :nav_item => {
              :url => @page.humanize_path,
              :link_text => @page.page_title,
              :link_title => @page.window_title
            },
            :creating_page => true
          )
        else
          redirect_to admin_site_pages_path(@site)
        end
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
    @page = @site.pages.new(params[:page])
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
