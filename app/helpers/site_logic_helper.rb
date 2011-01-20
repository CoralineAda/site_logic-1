module SiteLogicHelper

  def countdown_field(field_id,update_id,max,options = {})
    function = "$('#{update_id}').innerHTML = (#{max} - $F('#{field_id}').length);"
    count_field_tag(field_id,function,options)
  end
  
  def count_field(field_id,update_id,options = {})
    function = "$('#{update_id}').innerHTML = $F('#{field_id}').length;"
    count_field_tag(field_id,function,options)
  end
  
  def count_field_tag(field_id,function,options = {})  
    %{
      <script type="text/javascript">
        Event.observe($('#{field_id}'), 'keydown', function (){ #{function} });
      </script>
    }.html_safe
  end
end
