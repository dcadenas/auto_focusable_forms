require 'rubygems'
require 'spec'
 
$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__)


def focus_regexp field_name
  /\$\('#{field_name}'\)\.focus\(\)/
end

def assert_field_has_focus field, field_name = '\w+'
  field.should match(focus_regexp(field_name))
end

def assert_field_has_no_focus field, field_name = '\w+'
  field.should_not match(focus_regexp(field_name))
end
