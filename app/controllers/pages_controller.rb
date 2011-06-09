class PagesController < ApplicationController

  def show
    @site = Site.where(:domain => request.host).first || Site.first

    if @page = @site.pages.published.select{ |p| p.slug =~ /#{request.path}/i }.first || @site.home_page
      render :layout => @site.layout
    else
      redirect_to '/404'
    end
  end

end
