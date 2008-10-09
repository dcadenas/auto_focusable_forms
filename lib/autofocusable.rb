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
      super + set_focus(field)
    end
  end

private
  def set_focus method_name
    if @is_autofocusable && !@template.instance_variable_defined?("@focus_javascript_tag")
      @template.instance_variable_set('@focus_javascript_tag', @template.javascript_tag("$('#{tag_id(method_name)}').focus()"))
    else
      ''
    end
  end

  def tag_id field
    "#{sanitized_object_name}_#{sanitized_method_name field}"
  end

  def sanitized_object_name
    @sanitized_object_name ||= @object_name.to_s.gsub(/[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def sanitized_method_name field
    @sanitized_method_name ||= field.to_s.sub(/\?$/,"")
  end
end

