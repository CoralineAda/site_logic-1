class Admin::NavItemsController < ApplicationController

  before_filter :scope_site
  before_filter :scope_nav_item, :except => [:index, :new]

  def index
    @nav_items = @nav_items.sort{|a,b| a.position.to_i <=> b.position.to_i}
  end
  
  def new
    @nav_item = @site.nav_items.new
  end
  
  def create
    @nav_item = @site.nav_items.create(params[:nav_item])
    if @nav_item.valid?
      flash[:notice] = "Successfully created the navigation link."
      redirect_to admin_site_nav_items_path(@site)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @nav_item.update_attributes(params[:nav_item])
      flash[:notice] = "Successfully updated the navigation link."
      redirect_to admin_site_nav_items_path(@site)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @nav_item.destroy
    flash[:notice] = "Successfully destroyed the navigation link."
      redirect_to admin_site_nav_items_path(@site)
  end

	def reorder
		order = params[:content_list]
		order.each_with_index do |id, sort_order|
		  item = @site.nav_items.find(id)
			item.update_attributes(:position => sort_order + 1)
		end
		# Rails complains of a missing template without the following line.
		render :text => ''
	end

  private
  
  def scope_site
    @site = Site.find(params[:site_id])
    @nav_items = @site.nav_items
  end
  
  def scope_nav_item
    @nav_item = @site.nav_items.find(params[:id])
    @root_links = @site.nav_items.roots
  end
  
end
