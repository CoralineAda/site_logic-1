class Admin::RedirectsController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_site
  before_filter :scope_redirect, :except => [:index, :new, :create]

  def index
  end

  def new
    @redirect = @site.redirects.new
  end

  def create
    @redirect = @site.redirects.create(params[:redirect])
    if @redirect.valid?
      flash[:notice] = "Successfully created the redirect."
      redirect_to admin_site_redirects_path(@site)
    else
      render :action => 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @redirect.update_attributes(params[:redirect])
      flash[:notice] = "Successfully updated the redirect."
      redirect_to admin_site_redirects_path(@site)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @redirect.destroy
    flash[:notice] = "Successfully destroyed the redirect."
      redirect_to admin_site_redirects_path(@site)
  end

	def reorder
		order = params[:content_list]
		order.each_with_index do |id, sort_order|
		  item = @site.redirects.find(id)
			item.update_attributes(:position => sort_order + 1)
		end
		# Rails complains of a missing template without the following line.
		render :text => ''
	end

  private

  def scope_site
    @site = Site.find(params[:site_id])
    @redirects = @site.redirects
  end

  def scope_redirect
    @redirect = @site.redirects.find(params[:id])
  end

end
