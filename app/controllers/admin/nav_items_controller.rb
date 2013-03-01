class Admin::NavItemsController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_site
  before_filter :scope_nav_item, :except => [:index, :new, :create, :reorder]

  def index
    @primary_nav_items = @root_links.primary.sort{|a,b| a.position.to_i <=> b.position.to_i}
  end

  def new
    @roots = @site.nav_items.roots.sort{|a,b| a.link_text <=> b.link_text}
    kind = params[:kind] || 'Primary'
    if params[:parent_id] && params[:nav_item]
      @nav_item = @site.nav_items.new(params[:nav_item].merge(:parent_id => params[:parent_id], :site => @site, :kind => kind))
    elsif params[:parent_id]
      @nav_item = @site.nav_items.new(:parent_id => params[:parent_id], :site => @site, :kind => kind)
    elsif params[:nav_item]
      @nav_item = @site.nav_items.new(params[:nav_item].merge(:kind => kind))
    else
      @nav_item = @site.nav_items.new(:kind => kind)
    end
  end

  def create
    params[:nav_item][:parent_id] = nil if params[:nav_item][:parent_id].blank?
    @nav_item = @site.nav_items.create(params[:nav_item])
    if @nav_item.valid?
      flash[:notice] = "Successfully created the navigation link."
      if params[:nav_item][:creating_page]
        redirect_to admin_site_pages_path(@site.id.to_s)
      elsif @nav_item.parent_id.blank?
        redirect_to admin_site_nav_items_path(@site.id.to_s, :anchor => "#{@nav_item.kind.downcase}_nav")
      else
        redirect_to admin_site_nav_item_path(@site.id.to_s, @nav_item.parent_id)
      end
    else
      render :action => 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @nav_item.update_attributes(params[:nav_item])
      flash[:notice] = "Successfully updated the navigation link."
      redirect_to admin_site_nav_items_path(@site, :anchor => "#{@nav_item.kind.downcase}_nav")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @nav_item.destroy
    flash[:notice] = "Successfully destroyed the navigation link."
      redirect_to admin_site_nav_items_path(@site, :anchor => "#{@nav_item.kind.downcase}_nav")
  end

	def reorder
		order = params[:"content_list_#{params[:kind]}"]
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
    @root_links = @site.nav_items.roots
  end

  def scope_nav_item
    @nav_item = @site.nav_items.find(params[:id])
  end

  def auto_nav_item

  end

end
