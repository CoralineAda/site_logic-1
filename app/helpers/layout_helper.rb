module LayoutHelper
  include ScaffoldLogic::FormHelper
  include ScaffoldLogic::Helper
  include ScaffoldLogic::TabInterfaceHelper
  include SiteLogic::Helper

  def breadcrumbs
    unless controller?('home') && action?(/home|index/)
      html = [ link_to('Home', root_path) ]
#      html << link_to( 'Foo', foo_path ) if controller?('FoosController')
      (html * ' &gt; ').html_safe
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
