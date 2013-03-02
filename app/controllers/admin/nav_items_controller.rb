class Admin::NavItemsController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_site
  before_filter :scope_nav_item, :except => [:index, :new, :create, :reorder]

  def index
    @primary_nav_items = @root_links.primary.sort{|a,b| a.position.to_i <=> b.position.to_i}
  end

  def new
    @roots = @site.sorted_root_nav_items
    new_nav_item_from_request params[:kind] || 'Primary'
  end

  def create
    clear_blank_parent
    @nav_item = @site.nav_items.create(params[:nav_item])
    if @nav_item.valid?
      flash[:notice] = "Successfully created the navigation link."
      if creating_page_request?
        redirect_to admin_site_pages_path(@site.id.to_s)
      elsif @nav_item.root?
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

  def clear_blank_parent
    params[:nav_item][:parent_id] = nil if params[:nav_item][:parent_id].blank?
  end

  def creating_page_request?
    !! params[:nav_item][:creating_page]
  end

  def nav_item_request?
    !! params[:nav_item]
  end

  def new_nav_item_from_request kind
    if parent_request? && nav_item_request?
      @nav_item = @site.nav_items.new(params[:nav_item].merge(:parent_id => params[:parent_id], :site => @site, :kind => kind))
    elsif parent_request?
      @nav_item = @site.nav_items.new(:parent_id => params[:parent_id], :site => @site, :kind => kind)
    elsif nav_item_request?
      @nav_item = @site.nav_items.new(params[:nav_item].merge(:kind => kind))
    else
      @nav_item = @site.nav_items.new(:kind => kind)
    end
  end

  def parent_request?
    !! params[:parent_id]
  end

  def scope_site
    @site = Site.find(params[:site_id])
    @root_links = @site.nav_items.roots
  end

  def scope_nav_item
    @nav_item = @site.nav_items.find(params[:id])
  end
end