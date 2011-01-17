class RedirectsController < ApplicationController

  def show
    Rails.logger.info request.path
    if @redirect = @current_site.redirects.where(:source_url => "#{request.path}").first
      redirect_to @redirect.destination_url
    else
      redirect_to '/404'
    end
  end

end
