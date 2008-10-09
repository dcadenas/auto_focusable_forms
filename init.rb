require 'autofocusable'

#lets extend all instances of FormBuilder with our behaviour
#this lets us us super instead of method aliasing which has interesting advantages

module FormBuilderAutoFocusExtender
  def new *args
    returning super do |form_builder_instance|
      form_builder_instance.extend AutoFocusable
      form_builder_instance.init *args
    end
  end
end
ActionView::Helpers::FormBuilder.extend FormBuilderAutoFocusExtender
