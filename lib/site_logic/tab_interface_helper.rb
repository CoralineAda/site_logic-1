module SiteLogic
  module TabInterfaceHelper
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
      %{<li id="show_#{args[:id]}" class="tab_control #{args[:state]}" onclick="window.location='##{args[:id]}'; activate_tab('#{args[:id]}');">#{args[:label] || args[:id].to_s.titleize}</li>}.html_safe
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
end
