module AutoFocusable
  helpers = ActionView::Helpers::FormBuilder.field_helpers +
            %w{date_select time_select datetime_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for radio_button}

  helpers.each do |name|
    define_method(name) do |field, *args|
      super + set_focus(field)
    end
  end

  def init *args
    form_builder_options = get_form_builder_options(args)
    @is_autofocusable = form_builder_options[:autofocus] || !form_builder_options.has_key?(:autofocus)
  end

  def initialize *args
    super
    init *args
  end

  private
  def set_focus method_name
    if @is_autofocusable && @focus_javascript_tag.nil?
      @focus_javascript_tag = @template.javascript_tag "$('#{tag_id(method_name)}').focus()" 
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

  def get_form_builder_options args
    args.pop #we ignore the last parameter to find the options hash
    args.extract_options!
  end
end

