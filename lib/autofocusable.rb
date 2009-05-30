module AutoFocusable
  def self.extended form_builder_instance
    form_builder_instance.instance_eval do
      @is_autofocusable = true
      @is_autofocusable = @options[:autofocus] if @options.has_key?(:autofocus)
    end
  end

  helpers = ActionView::Helpers::FormBuilder.field_helpers +
            %w{date_select time_select datetime_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for radio_button}

  helpers.each do |name|
    define_method(name) do |field, *args|
      super + set_focus(field, args.extract_options!)
    end
  end

private
  def set_focus method_name, options
    return '' if is_disabled?(options) || is_readonly?(options)
    
    if @is_autofocusable && !@template.instance_variable_defined?('@focus_was_set')
      @template.instance_variable_set('@focus_was_set', @template.javascript_tag(<<-JSCODE))
        document.getElementById('#{tag_id(method_name)}').focus();
        document.getElementById('#{tag_id(method_name)}').value = document.getElementById('#{tag_id(method_name)}').value;
      JSCODE
    else
      ''
    end
  end
  
  def is_disabled? options
    options.has_key?(:disabled) && options[:disabled] != false  
  end

  def is_readonly? options
    options.has_key?(:readonly) && options[:readonly] != false  
  end

  def tag_id field
    "#{sanitized_object_name}_#{sanitized_method_name field}"
  end

  def sanitized_object_name
    @sanitized_object_name ||= @object_name.to_s.gsub(/[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def sanitized_method_name field
    field.to_s.sub(/\?$/,"")
  end
end

