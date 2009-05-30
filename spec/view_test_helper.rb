require 'activesupport'
require 'active_support'
require 'actionpack'
require 'action_controller'
require 'action_view'
require 'rexml/document'
require 'rspec_hpricot_matchers'

module ViewTestHelper
  attr_accessor :output_buffer

  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::ActiveRecordHelper
  include ActionView::Helpers::RecordIdentificationHelper
  include ActionView::Helpers::CaptureHelper
  include ActiveSupport
  include ActionController::PolymorphicRoutes

  def protect_against_forgery?
    false
  end

  def create_active_record_instance_variable ar_class_name, attributes = {}
    self.class.send :define_method, "#{ar_class_name.underscore}_path" do "/#{ar_class_name.underscore.pluralize}/1" end
    self.class.send :define_method, "#{ar_class_name.underscore.pluralize}_path" do "/#{ar_class_name.underscore.pluralize}" end
    self.class.send :define_method, "new_#{ar_class_name.underscore}_path" do "/#{ar_class_name.underscore.pluralize}/new" end

    ar_class = create_class ar_class_name
    ar_instance_variable = instance_variable_set("@#{ar_class_name.underscore}", mock(ar_class_name.underscore))
    ar_instance_variable.stub!(:class).and_return(ar_class)
    ar_instance_variable.stub!(:id).and_return(nil)
    attributes.each_pair do |field, value|
      ar_instance_variable.stub!(field).and_return(value)
    end
    ar_instance_variable.stub!(:new_record?).and_return(true)
    ar_instance_variable.stub!(:errors).and_return(mock('errors', :on => nil))
  end

  def create_class class_name
    Object.const_set(class_name.camelize, Class.new) unless Object.const_defined? class_name.camelize
    Object.const_get(class_name.camelize)
  end
end
