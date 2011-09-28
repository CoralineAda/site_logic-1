class PagesController < ApplicationController
  def show
    @site = Site.where(:domain => request.host).first || Site.first

    if @page = @site.pages.published.select{ |p| p.slug =~ /#{params[:path]}/i }.first
      render :layout => @site.layout
    else
      raise Mongoid::Errors::DocumentNotFound.new Page, params[:path]
    end
  end
end