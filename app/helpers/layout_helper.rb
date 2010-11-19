# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  SELECT_PROMPT = 'Select...'
  SELECT_PROMPT_OPTION = "<option value=''>#{SELECT_PROMPT}</option>"

  def action?( expression )
    !! ( expression.class == Regexp ? controller.action_name =~ expression : controller.action_name == expression )
  end


  def breadcrumbs
    unless controller?('home') && action?(/home|index/)
      html = [ link_to('Home', root_path) ]
#      html << link_to( 'Foo', foo_path ) if controller?('FoosController')
      (html * ' &gt; ').html_safe
    end
  end

  def checkmark
    %{<div class="checkmark"></div>}
  end

  def controller?( expression )
    !! ( expression.class == Regexp ? controller.controller_name =~ expression : controller.controller_name == expression )
  end

  # Display CRUD icons or links, according to setting in use_crud_icons method.
  #
  # In application_helper.rb:
  #
  #   def use_crud_icons
  #     true
  #   end
  #
  # Then use in index views like this:
  #
  # <td class="crud_links"><%= crud_links(my_model, 'my_model', [:show, :edit, :delete]) -%></td>
  #
  def crud_links(model, instance_name, actions, args={})
    _html = ''
    _path = args.delete(:path) || model
    _edit_path = args.delete(:edit_path) || eval("edit_#{instance_name}_path(model)") if actions.include?(:edit)
    _options = args.empty? ? '' : ", #{args.map{|k,v| ":#{k} => #{v}"}}"

    if use_crud_icons
      _html << link_to(image_tag('icons/view.png', :class => 'crud_icon', :width => 14, :height => 14), _path, :title => "View#{_options}") if actions.include?(:show)
      _html << link_to(image_tag('icons/edit.png', :class => 'crud_icon', :width => 14, :height => 14), _edit_path, :title => "Edit#{_options}") if actions.include?(:edit)
      _html << link_to(image_tag('icons/delete.png', :class => 'crud_icon', :width => 14, :height => 14), _path, :confirm => 'Are you sure? This action cannot be undone.', :method => :delete, :title => "Delete#{_options}") if actions.include?(:delete)
    else
      _html << link_to('View', _path, :title => 'View', :class => "crud_link#{_options}") if actions.include?(:show)
      _html << link_to('Edit', _edit_path, :title => 'Edit', :class => "crud_link#{_options}") if actions.include?(:edit)
      _html << link_to('Delete', _path, :confirm => 'Are you sure? This action cannot be undone.', :method => :delete, :title => 'Delete', :class => "crud_link#{_options}") if actions.include?(:delete)
    end

    _html.html_safe
  end

  # Display CRUD icons or links, according to setting in use_crud_icons method.
  # This method works with nested resources.
  # Use in index views like this:
  #
  # <td class="crud_links"><%= crud_links_for_nested_resource(@my_model, my_nested_model, 'my_model', 'my_nested_model', [:show, :edit, :delete]) -%></td>
  #
  def crud_links_for_nested_resource(model, nested_model, model_instance_name, nested_model_instance_name, actions, args={})
    crud_links model, model_instance_name, actions, args.merge(:edit_path => eval("edit_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model)"), :path => [model, nested_model])
  end

  def faux_field(label, content)
    %{<label>#{label}</label><br /><div class="faux_field">#{content}</div>}.html_safe
  end
  
  # DRY way to return a legend tag that renders correctly in all browsers. This variation allows
  # for more "stuff" inside the legend tag, e.g. expand/collapse controls, without having to worry
  # about escape sequences.
  #
  # Sample usage:
  #
  #   <%- legend_block do -%>
  #     <span id="hide_or_show_backlinks" class="show_link" style="background-color: #999999;
  #     border: 1px solid #999999;" onclick="javascript:hide_or_show('backlinks');"></span>Backlinks (<%=
  #     @google_results.size -%>)
  #   <%- end -%>
  #
  def legend_block(&block)
    concat content_tag(:div, capture(&block), :class => "faux_legend")
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

  # Create a link that is opaque to search engine spiders.
  def obfuscated_link_to(path, image, label, args={})
    _html = %{<form action="#{path}" method="get" style="display: inline;" class="obfuscated_link">}
    _html << %{ <fieldset><input src="#{image}" type="image" /></fieldset>}
    args.each{ |k,v| _html << %{  <input id="#{k.to_s}" name="#{k}" type="hidden" value="#{v}" />} }
    _html << %{</form>}
    _html
  end

  # Displays a nicely formatted notification with an appropriate icon.
  #
  # Usage example:
  #
  #   <%= note(:idea, 'There are 23 geographic terms in the related keywords. You should consider
  #                    promoting some of these terms to the keyword project.) -%>
  #
  # Kinds are:
  #
  #   :detail
  #     Provides detailed information about something.
  #   :info
  #     Provides general information about something.
  #   :reminder
  #     Recommends that the user take action.
  #   :error
  #     Notifies the user that an error has occurred.
  #   :alert
  #     Notifies the user that something important has happened.
  #   :idea
  #     Suggests something to the user based on a heuristic.
  #   :clarification
  #     Provide an explanation of something that has happened.
  #   :question
  #     Prompts the user.
  #   :confusion
  #     WTF?
  #
  def note(kind, content)
    return unless content
    kind = :info unless kind && [:detail, :info, :reminder, :error, :alert, :idea, :clarification, :question, :confusion].include?(kind)
    %{<div class="note"><span class="notification #{kind.to_s}"></span><p>#{content}</p></div>}
  end
  
  # Creates a link that will open in a new window, with the appropriate icon indicating this.
  def remote_link_to(url, link_text, link_title=nil)
    link_title ||= "Open #{url} in a new window"
    %{<a href="#{url}" onclick="window.open(this.href);return false;" title="#{link_title}">#{link_text}&nbsp;<img src="/images/icons/link_icon.png" alt="" width="14" height="12" /></a>}
  end
  
  def set_title(title = nil)
    if title.nil?
      content_for(:title) { 'RemarkIT' }
      content_for(:page_title) {  }
    else
      content_for(:title) { title + ' - RemarkIT' }
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

  # Returns a string of HTML option tags for the given array of option values. Specify the selected value for stickiness. Intended for use with MirUtility's ActiveRecord::Base.to_option_values.
  def tags_for_option_values( a, selected = nil )
    SELECT_PROMPT_OPTION + a.map{ |_e| _flag = _e[1].to_s == selected ? 'selected="1"' : ''; _e.is_a?(Array) ? "<option value=\"#{_e[1]}\" #{_flag}>#{_e[0]}</option>" : "<option>#{_e}</option>" }.to_s
  end

  # Use on index pages to create dropdown list of filtering criteria.
  # Populate the filter list using a constant in the model corresponding to named scopes.
  #
  # Usage:
  #
  # - item.rb:
  #
  #     named_scope :active, :conditions => { :is_active => true }
  #
  #     FILTERS_BY_NAMED_SCOPE = {
  #       'all' => 'All',
  #       'active' => 'Active Only'
  #     }
  #
  # - items/index.html.erb:
  #
  #     <%= select_tag_for_filter(Item, params) -%>
  #
  # - items_controller.rb:
  #
  #     def index
  #       if Item::FILTERS_BY_NAMED_SCOPE.keys.include?(params[:show])
  #         @items = Item.send(params[:show]).order_by(sanitize_by_param(Item::SORTABLE_COLUMNS), sanitize_dir_param)
  #       else
  #         @items = Item.order_by(sanitize_by_param(Item::SORTABLE_COLUMNS), sanitize_dir_param)
  #       end
  #       ...
  #     end
  #
  # Replace show/edit/delete links with icons in index views?
  def use_crud_icons
    true
  end
  
  # Tabbed interface helpers =======================================================================

  # Returns formatted tabs with appropriate JS for activation. Use in conjunction with tab_body.
  #
  # Usage:
  #
  #   <%- tabset do -%>
  #     <%= tab_tag :id => 'ppc_ads', :label => 'PPC Ads', :state => 'active' %>
  #     <%= tab_tag :id => 'budget' %>
  #     <%= tab_tag :id => 'geotargeting' %>
  #   <%- end -%>
  #
  def tabset(&block)
    concat %{
      <div class="jump_links">
        <ul>
    }.html_safe
    yield
    concat %{
        </ul>
      </div>
      <br style="clear: both;" /><br />
      <input type="hidden" id="show_tab" />
      <script type="text/javascript">
        function hide_all_tabs() { $$('.tab_block').invoke('hide'); }
        function activate_tab(tab) {
          $$('.tab_control').each(function(elem){ elem.className = 'tab_control'});
          $('show_' + tab).className = 'tab_control active';
          hide_all_tabs();
          $(tab).toggle();
          $('show_tab').value = tab
        }
        function sticky_tab() { if (location.hash) { activate_tab(location.hash.gsub('#','')); } }
        Event.observe(window, 'load', function() { sticky_tab(); });
      </script>
    }.html_safe
    return ''
  end

  # Returns a tab body corresponding to tabs in a tabset. Make sure that the id of the tab_body
  # matches the id provided to the tab_tag in the tabset block.
  #
  # Usage:
  #
  #   <%- tab_body :id => 'ppc_ads', :label => 'PPC Ad Details' do -%>
  #     PPC ads form here.
  #   <%- end -%>
  #
  #   <%- tab_body :id => 'budget' do -%>
  #     Budget form here.
  #   <%- end -%>
  #
  #   <%- tab_body :id => 'geotargeting' do -%>
  #     Geotargeting form here.
  #   <%- end -%>
  #
  def tab_body(args, &proc)
    concat %{<div id="#{args[:id]}" class="tab_block form_container" style="display: #{args[:display] || 'none'};">}.html_safe
    concat %{#{legend_tag args[:label] || args[:id].titleize }}.html_safe
    concat %{<a name="#{args[:id]}"></a><br />}.html_safe
    yield
    concat %{</div>}.html_safe
    return ''
  end

  # Returns the necessary HTML for a particular tab. Use inside a tabset block.
  # Override the default tab label by specifying a :label parameter.
  # Indicate that the tab should be active by setting its :state to 'active'.
  # (NOTE: You must define a corresponding  CSS style for active tabs.)
  #
  # Usage:
  #
  #   <%= tab_tag :id => 'ppc_ads', :label => 'PPC Ads', :state => 'active' %>
  #
  def tab_tag(args, *css_class)
    %{<li id="show_#{args[:id]}" class="tab_control #{args[:state]}" onclick="window.location='##{args[:id]}'; activate_tab('#{args[:id]}');">#{args[:label] || args[:id].to_s.titleize}</li>
    <li>|</li>}.html_safe
  end

  # Create a set of tags for displaying a field label with inline help.
  # Field label text is appended with a ? icon, which responds to a click
  # by showing or hiding the provided help text.
  #
  # Sample usage:
  #
  #   <%= tag_for_label_with_inline_help 'Relative Frequency', 'rel_frequency', 'Relative frequency of search traffic for this keyword across multiple search engines, as measured by WordTracker.' %>
  #
  # Yields:
  #
  #   <label for="rel_frequency">Relative Frequency: <%= image_tag "/images/help_icon.png", :onclick => "$('rel_frequency_help').toggle();", :class => 'inline_icon' %></label><br />
  #   <div class="inline_help" id="rel_frequency_help" style="display: none;">
  #     <p>Relative frequency of search traffic for this keyword across multiple search engines, as measured by WordTracker.</p>
  #   </div>
  def tag_for_label_with_inline_help( label_text, field_id, help_text )
    _html = ""
    _html << %{<label for="#{field_id}">#{label_text}}
    _html << %{<img src="/images/icons/help_icon.png" onclick="$('#{field_id}_help').toggle();" class='inline_icon' />}
    _html << %{</label><br />}
    _html << %{<div class="inline_help" id="#{field_id}_help" style="display: none;">}
    _html << %{<p>#{help_text}</p>}
    _html << %{</div>}
    _html
  end

  # Create a set of tags for displaying a field label followed by instructions.
  # The instructions are displayed on a new line following the field label.
  #
  # Usage:
  #
  #   <%= tag_for_label_with_instructions 'Status', 'is_active', 'Only active widgets will be visible to the public.' %>
  #
  # Yields:
  #
  #   <label for="is_active">
  #     Status<br />
  #     <span class="instructions">Only active widgets will be visible to the public.</span>
  #   <label><br />
  def tag_for_label_with_instructions( label_text, field_id, instructions )
    _html = ""
    _html << %{<label for="#{field_id}">#{label_text}}
    _html << %{<span class="instructions">#{instructions}</span>}
    _html << %{</label><br />}
    _html
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