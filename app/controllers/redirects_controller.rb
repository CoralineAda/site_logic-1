class RedirectsController < ApplicationController

  def show
    @redirect = @current_site.redirects.where(:source_url => "/#{params[:source_url]}").first
    redirect_to @redirect.destination_url
  end

end
