# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  include ScaffoldLogic::TabInterfaceHelper

  SELECT_PROMPT = 'Select...'
  SELECT_PROMPT_OPTION = "<option value=''>#{SELECT_PROMPT}</option>"

  def breadcrumbs
    unless controller?('home') && action?(/home|index/)
      html = [ link_to('Home', root_path) ]
#      html << link_to( 'Foo', foo_path ) if controller?('FoosController')
      (html * ' &gt; ').html_safe
    end
  end

  def faux_field(label, content)
    %{<label>#{label}</label><br /><div class="faux_field">#{content}</div>}.html_safe
  end

  # DRY way to return a legend tag that renders correctly in all browsers
  #
  # Sample usage:
  #
  #   <%= legend_tag "Report Criteria" -%>
  #
  # Sample usage with help text:
  #
  #   <%= legend_tag "Report Criteria", :help => "Some descriptive copy here." -%>
  #     <span id="hide_or_show_backlinks" class="show_link" style="background-color: #999999;
  #     border: 1px solid #999999;" onclick="javascript:hide_or_show('backlinks');"></span>Backlinks (<%=
  #     @google_results.size -%>)
  #   <%- end -%>
  #
  # Recommended CSS to support display of help icon and text:
  #
  #     .help_icon {
  #       display: block;
  #       float: left;
  #       margin-top: -16px;
  #       margin-left: 290px;
  #       border-left: 1px solid #444444;
  #       padding: 3px 6px;
  #       cursor: pointer;
  #     }
  #
  #     div.popup_help {
  #       color: #666666;
  #       width: 98%;
  #       background: #ffffff;
  #       padding: 1em;
  #       border: 1px solid #999999;
  #       margin: 1em 0em;
  #     }
  #
  def legend_tag(text, args={})
    args[:id] ||= text.downcase.gsub(/ /,'_')
    if args[:help]
      _html = %{<div id="#{args[:id]}" class="faux_legend">#{text}<span class="help_icon" onclick="$('#{args[:id]}_help').toggle();">?</span></div>\r}
      _html << %{<div id="#{args[:id]}_help" class="popup_help" style="display: none;">#{args[:help]}<br /></div>\r}
    else
      _html = %{<div id="#{args[:id]}" class="faux_legend">#{text}</div>\r}
    end
    _html.gsub!(/ id=""/,'')
    _html.gsub!(/ class=""/,'')
    _html.html_safe
  end

  def meta_description(content=nil)
    content_for(:meta_description) { content } unless content.blank?
  end

  def meta_keywords(content=nil)
    content_for(:meta_keywords) { content } unless content.blank?
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

  # Returns a link_to tag with sorting parameters that can be used with ActiveRecord.order_by.
  #
  # To use standard resources, specify the resources as a plural symbol:
  #   sort_link(:users, 'email', params)
  #
  # To use resources aliased with :as (in routes.rb), specify the aliased route as a string.
  #   sort_link('users_admin', 'email', params)
  #
  # You can override the link's label by adding a labels hash to your params in the controller:
  #   params[:labels] = {'user_id' => 'User'}
  def sort_link(model, field, params, html_options={})
    if (field.to_sym == params[:by] || field == params[:by]) && params[:dir] == "ASC"
      classname = "arrow-asc"
      dir = "DESC"
    elsif (field.to_sym == params[:by] || field == params[:by])
      classname = "arrow-desc"
      dir = "ASC"
    else
      dir = "ASC"
    end

    options = {
      :anchor => html_options[:anchor],
      :by => field,
      :dir => dir,
      :search => params[:search],
      :category => params[:category],
      :show => params[:show]
    }

    options[:show] = params[:show] unless params[:show].blank? || params[:show] == 'all'

    html_options = {
      :class => "#{classname} #{html_options[:class]}",
      :style => "color: white; font-weight: #{params[:by] == field ? "bold" : "normal"}; #{html_options[:style]}",
      :title => "Sort by this field"
    }

    field_name = params[:labels] && params[:labels][field] ? params[:labels][field] : field.titleize

    _link = model.is_a?(Symbol) ? eval("#{model}_url(options)") : "/#{model}?#{options.to_params}"
    link_to(field_name, _link, html_options)
  end

  def tab_for(link, link_title, tab_name, *disabled)
    js_link = " onclick=\"javascript:window.location='#{link}'\""
    js_link = " onclick=\"#{feature_teaser_popup}\"" unless disabled.empty?
    html = "<li id=\"#{tab_name}\" "
    html << "class=\"here\" " if @active_tab == tab_name
    html << js_link + ">"
    html << link_to( link_title, link, :title => link_title, :onclick => disabled.empty? ? "" : feature_teaser_popup )
    html << "</li>"
    html
  end
end

class Hash
  def to_params
    params = ''
    stack = []

    each do |k, v|
      if v.is_a?(Hash)
        stack << [k,v]
      elsif v.is_a?(Array)
        stack << [k,Hash.from_array(v)]
      else
        params << "#{k}=#{v}&"
      end
    end

    stack.each do |parent, hash|
      hash.each do |k, v|
        if v.is_a?(Hash)
          stack << ["#{parent}[#{k}]", v]
        else
          params << "#{parent}[#{k}]=#{v}&"
        end
      end
    end

    params.chop!
    params
  end
end
