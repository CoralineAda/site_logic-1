class PagesController < ApplicationController
  def show
    @site = Site.where(:domain => request.host).first || Site.first
    slug = params[:path].blank? ? '/' : params[:path]

    if @page = @site.pages.published.by_slug(slug).first
      render :layout => @site.layout
    else
      raise Mongoid::Errors::DocumentNotFound.new Page, slug
    end
  end
end