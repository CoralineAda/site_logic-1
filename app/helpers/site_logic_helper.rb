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

  def crud_links_for_admin(model, instance_name, actions, args={})
    crud_links model, instance_name, actions, args.merge(
      :edit_path => eval("edit_admin_#{instance_name}_path(model)"), :path => [model],
      :new_path => eval("new_admin_#{instance_name}_path(model)"), :path => [model],
      :view_path => eval("admin_#{instance_name}_path(model)"), :path => [model],
      :delete_path => eval("admin_#{instance_name}_path(model)"), :path => [model]
    )
  end

  def crud_links_for_nested_admin(model, nested_model, model_instance_name, nested_model_instance_name, actions, args={})
    crud_links model, model_instance_name, actions, args.merge(
      :edit_path => eval("edit_admin_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model)"), :path => [model],
      :new_path => eval("new_admin_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model)"), :path => [model],
      :view_path => eval("admin_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model)"), :path => [model],
      :delete_path => eval("admin_#{model_instance_name}_#{nested_model_instance_name}_path(model, nested_model)"), :path => [model]
    )
  end

end
