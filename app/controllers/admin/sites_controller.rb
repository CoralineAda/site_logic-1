class Admin::SitesController < ApplicationController

  def index
    @sites = Site.all
  end
  
  def show
    @site = Site.find(params[:id])
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
    @site = Site.find(params[:id])
  end
  
  def update
    @site = Site.find(params[:id])
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
    @site = Site.find(params[:id])
    @site.destroy
    flash[:notice] = "Successfully destroyed site."
    redirect_to admin_sites_url
  end

end