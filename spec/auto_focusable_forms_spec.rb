require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/view_test_helper'
require File.dirname(__FILE__) + '/../init'

describe 'auto focusable form' do
  include ViewTestHelper

  before do
    create_active_record_instance_variable 'post', :title => '', :content => ''
    create_active_record_instance_variable 'author', :name => '', :surname => ''
  end

  it 'should give focus only to the first element of the form' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title
        second_input = f.text_field :content
      end
    end

    assert_field_has_focus first_input
    assert_field_has_no_focus second_input
  end

  it 'should allow disabling autofocus' do
    first_input = second_input = ''

    capture do
      form_for @post, :autofocus => false do |f|
        first_input = f.text_field :title
        second_input = f.text_field :content
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_no_focus second_input
  end

  it 'should use the correct input field name' do
    title_input = ''

    capture do
      form_for @post do |f|
        title_input = f.text_field :title
      end
    end

    assert_field_has_focus title_input, 'post_title'
  end

  it 'should give focus only to the first field even if fields_for exists' do
    first = second = inner_first = inner_second = ''

    capture do
      form_for @post do |f|
        first = f.text_field :title
        fields_for @author do |g|
          inner_first = g.text_field :name
          inner_second = g.text_field :surname
        end
        second = f.text_field :content
      end
    end

    assert_field_has_focus first
    assert_field_has_no_focus inner_first
    assert_field_has_no_focus inner_second
    assert_field_has_no_focus second
  end

  it 'should give focus to the first element of an inner fields_for if it is the first element in the forms_form' do
    first = second = inner_first = inner_second = ''

    capture do
      form_for @post do |f|
        fields_for @author do |g|
          inner_first = g.text_field :name
          inner_second = g.text_field :surname
        end
        first = f.text_field :title
        second = f.text_field :content
      end
    end

    assert_field_has_focus inner_first
    assert_field_has_no_focus inner_second
    assert_field_has_no_focus first
    assert_field_has_no_focus second
  end

  it 'should give focus to the first form when two forms exist' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title
      end

      form_for @post do |f|
        second_input = f.text_field :title
      end
    end

    assert_field_has_focus first_input
    assert_field_has_no_focus second_input
  end

  it 'should give focus to the second form when the first has :autofocus => false' do
    first_input = second_input = ''

    capture do
      form_for @post, :autofocus => false do |f|
        first_input = f.text_field :title
      end

      form_for @author do |f|
        second_input = f.text_field :name
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_focus second_input
  end

  it 'should give focus to the second input when the first has :disabled => "something"' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :disabled => 'something'
        second_input = f.text_field :content
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_focus second_input
  end

  it 'should give focus to the second input when the first has :disabled => true' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :disabled => true
        second_input = f.text_field :content
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_focus second_input
  end

  it 'should still give focus to the first input when is :disabled => false' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :disabled => false
        second_input = f.text_field :content
      end
    end

    assert_field_has_focus first_input
    assert_field_has_no_focus second_input
  end

  it 'should give focus to the second input when the first has :readonly => "something"' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :readonly => 'something'
        second_input = f.text_field :content
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_focus second_input
  end

  it 'should give focus to the second input when the first has :readonly => true' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :readonly => true
        second_input = f.text_field :content
      end
    end

    assert_field_has_no_focus first_input
    assert_field_has_focus second_input
  end

  it 'should still give focus to the first input when is :readonly => false' do
    first_input = second_input = ''

    capture do
      form_for @post do |f|
        first_input = f.text_field :title, :readonly => false
        second_input = f.text_field :content
      end
    end

    assert_field_has_focus first_input
    assert_field_has_no_focus second_input
  end
end
