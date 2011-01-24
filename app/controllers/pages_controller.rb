class PagesController < ApplicationController

  def show
    @site = Site.where(:domain => request.host).first || Site.first
    if ! params[:nested_slug].blank?
      @page = @site.pages.published.where(:slug => "/#{params[:page_slug]}/#{params[:nested_slug]}/").first
    elsif params[:page_slug]
      @page = @site.pages.published.where(:slug => params[:page_slug]).first
      @page = @site.pages.published.where(:slug => "/#{params[:page_slug]}/").first unless @page
    elsif params[:path]
      @page = @site.pages.published.where(:slug => params[:path]).first
      @page = @site.pages.published.where(:slug => "/#{params[:path]}/").first unless @page
    else
      @page = @site.home_page
    end
    if @page
      render :layout => @site.layout
    else
      redirect_to '/404'
    end
  end

end
