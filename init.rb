require 'autofocusable'
extension = Module.new do
  def new *args
    instance = super
    instance.extend AutoFocusable
    instance.init *args
    instance
  end
end

ActionView::Helpers::FormBuilder.extend extension
