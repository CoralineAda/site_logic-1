module LayoutHelper
  include ScaffoldLogic::FormHelper
  include ScaffoldLogic::Helper
  include ScaffoldLogic::TabInterfaceHelper

  def breadcrumbs
    unless controller?('home') && action?(/home|index/)
      html = [ link_to('Home', root_path) ]
      html * ''
    end
  end

  def set_title(title = nil, window_title = nil)
    app_name ||= 'SEO Logic'
    window_title ||= title
    if title.nil?
      content_for(:title) { app_name }
      content_for(:page_title) {  }
    else
      content_for(:title) { window_title + " - #{app_name}" }
      content_for(:page_title) { title }
    end
  end
end
