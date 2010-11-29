class PagesController < ApplicationController

  def show
    Rails.logger.info("!!! => #{request.domain}")
    @site = Site.where(:domain => request.domain).first
    if params[:nested_slug]
      @page = @site.pages.where(:slug => "/#{params[:page_slug]}/#{params[:nested_slug]}").first
    elsif params[:page_slug]
      @page = @site.pages.where(:slug => params[:page_slug]).first
    else
      @page = @site.home_page
    end
    render :layout => @site.layout
  end
  
end
