class Admin::PagesController < ApplicationController

  before_filter :scope_site
  before_filter :scope_page, :only => [:edit, :update, :destroy, :show]
  
  uses_tiny_mce :options => {
    :mode => "textareas",
    :theme => "advanced",
    :editor_selector => "mceCustom",
    :plugins => %w{ safari style table advimage advlink media visualchars nonbreaking xhtmlxtras },
    :extended_valid_elements => "li[value], object[classid|codebase|width|height|align], param[name|value], embed[quality|type|pluginspage|width|height|src|align|wmode]",
    :theme_advanced_buttons1 => %w{ help code attribs cleanup | undo redo removeformat | styleprops bold italic underline strikethrough | bullist numlist | outdent indent blockquote | link unlink anchor image media | hr nonbreaking | charmap advhr cite abbr acronym },
    :theme_advanced_buttons2 => %w{  },
    :theme_advanced_buttons3 => %w{  },
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_statusbar_location => "bottom",
    :relative_urls => false,
    :document_base_url => "/",
    :theme_advanced_styles => "",
    :content_css => ''
  }
  
  def show
  end
  
  def new
    @page = @site.pages.new
  end
  
  def create
    @page = @site.pages.create(params[:page])
    if @page.valid?
      @page.publish! if params[:page][:state] == 'Published'
      flash[:notice] = "Successfully created the page."
      redirect_to admin_site_path(@site)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @page.update_attributes(params[:page])
      @page.publish! if params[:page][:state] == 'Published'
      @page.unpublish! if params[:page][:state] == 'Draft'
      flash[:notice] = "Successfully updated the page."
      redirect_to admin_site_path(@site)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @page.destroy
    flash[:notice] = "Successfully destroyed the page."
    redirect_to admin_site_path(@site)
  end

  private
  
  def scope_site
    @site = Site.find(params[:site_id])
  end
  
  def scope_page
    @page = @site.pages.find(params[:id])
  end
  
end