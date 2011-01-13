class SiteLogic::PagesController < SiteLogic::ApplicationController

  def show
    @site = Site.where(:domain => request.host).first
    if ! params[:nested_slug].blank?
      @page = @site.pages.where(:slug => "/#{params[:page_slug]}/#{params[:nested_slug]}").first
    elsif params[:page_slug]
      @page = @site.pages.where(:slug => params[:page_slug]).first
      @page = @site.pages.where(:slug => "/#{params[:page_slug]}/").first unless @page
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
