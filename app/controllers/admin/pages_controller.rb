class Admin::PagesController < ApplicationController
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
    params[:by] ||= 'humanize_path'
    params[:dir] ||= 'asc'
    @pages = @site.pages.sort_by{ |p| p.send(params[:by]).to_s }
    @pages.reverse! if params[:dir] == 'desc'
  end

  def show
  end

  def new
    @page = @site.pages.new
  end

  def create
    if preview_request?
      @page = @site.pages.new params[:page]
      render :action => 'preview', :layout => @site.layout
    else
      @page = @site.pages.create params[:page]
      if @page.valid?
        @page.publish! if publish_request?
        flash[:notice] = 'Successfully created the page.'
        if create_nav_item_request?
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
          redirect_after_write
        end
      else
        render :action => 'new'
      end
    end
  end

  def edit
  end

  def update
    if preview_request?
      @page = @site.pages.new params[:page]
      render :action => 'preview', :layout => @page.site.layout
    else
      if @page.update_attributes params[:page]
        @page.publish! if publish_request?
        @page.unpublish! if draft_request?
        flash[:notice] = 'Successfully updated the page.'
        redirect_after_write
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @page.destroy
    flash[:notice] = 'Successfully destroyed the page.'
    redirect_after_write
  end

  def preview
    @page = @site.pages.new params[:page]
    render :layout => @page.site.layout
  end

  private

  def create_nav_item_request?
    params[:page][:create_navigation_item] == 'true'
  end

  def draft_request?
    params[:page][:state] == 'Draft'
  end

  def preview_request?
    params[:commit] == 'Preview'
  end

  def publish_request?
    params[:page][:state] == 'Published'
  end

  def redirect_after_write
    redirect_to Site.count > 1 ? admin_site_path(@site) : admin_site_pages_path(@site)
  end

  def scope_site
    @site = Site.find params[:site_id]
  end

  def scope_page
    @page = @site.pages.find params[:id]
  end
end