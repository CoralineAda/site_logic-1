class Admin::SitesController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :find_site, :only => [:destroy, :edit, :show, :update]

  def index
    @sites = Site.all
  end

  def show
    params[:labels] = {
      :updated_at => 'Last Updated',
      :humanize_path => 'URL'
    }
    params[:by] ||= 'humanize_path'
    params[:dir] ||= 'asc'
    @pages = @site.sorted_pages(params[:by])
    @pages.reverse! if params[:dir] == 'desc'
    @nav_items = @site.nav_items.roots.sort_by{ |ni| ni.position.to_i }
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      @site.activate! if params[:site][:state] == 'Active'
      flash[:notice] = "Successfully created site."
      redirect_to admin_site_path(@site)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @site.update_attributes(params[:site])
      @site.activate! if params[:site][:state] == 'Active'
      @site.deactivate! if params[:site][:state] == 'Inactive'
      flash[:notice] = "Successfully updated site."
      redirect_to admin_site_path(@site)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @site.destroy
    flash[:notice] = "Successfully destroyed site."
    redirect_to admin_sites_url
  end

  private

  def find_site
    @site = Site.find params[:id]
  end
end