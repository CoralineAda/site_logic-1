class SiteLogic::Admin::SitesController < SiteLogic::ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')

  def index
    @sites = Site.all
  end
  
  def show
    params[:labels] = {
      :updated_at => 'Last Updated',
      :humanize_path => 'URL'
    }
    @site = Site.find(params[:id])
    params[:by] ||= 'humanize_path'; params[:dir] ||= 'ASC'
    @pages = @site.pages.sort{|a,b| a.send(params[:by]) <=> b.send(params[:by])}
    @pages.reverse! if params[:dir] == 'DESC'
    @redirects = @site.redirects
    @nav_items = @site.nav_items.roots.sort{|a,b| a.position.to_i <=> b.position.to_i}
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
