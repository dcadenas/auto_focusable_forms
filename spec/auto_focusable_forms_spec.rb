require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/view_test_helper'
require File.dirname(__FILE__) + '/../init'

describe 'auto focusable' do
  include ViewTestHelper

  setup do
    create_active_record_instance_variable 'post', :title => '', :content => ''
    create_active_record_instance_variable 'author', :name => '', :surname => ''
  end

  %w(form_for fields_for).each do |form_helper|
    describe form_helper do
      it 'should give focus only to the first element of the form' do
        _erbout = first = second = ''

        send form_helper, @post, :autofocus => true do |f|
          first = f.text_field :title
          second = f.text_field :content
        end

        assert_field_has_focus first
        assert_field_has_no_focus second
      end

      it 'should be optional to use :autofocus => true' do
        _erbout = first = second = ''

        form_for @post do |f|
          first = f.text_field :title
          second = f.text_field :content
        end

        assert_field_has_focus first
        assert_field_has_no_focus second
      end

      it 'should allow disabling autofocus' do
        _erbout = first = second = ''

        form_for @post, :autofocus => false do |f|
          first = f.text_field :title
          second = f.text_field :content
        end

        assert_field_has_no_focus first
        assert_field_has_no_focus second
      end
    end
  end

  it 'should give focus to the correct input field name' do
    _erbout = title_input = ''

    form_for @post do |f|
      title_input = f.text_field :title
    end

    assert_field_has_focus title_input, 'post_title'
  end

  it 'should give focus to the inner fields_for first input and outer form_for' do
    _erbout = first = second = inner_first = inner_second = ''

    form_for @post do |f|
      first = f.text_field :title
      fields_for @author do |g|
        inner_first = g.text_field :name
        inner_second = g.text_field :surname
      end
      second = f.text_field :content
    end

    assert_field_has_focus first
    assert_field_has_focus inner_first
    assert_field_has_no_focus second
    assert_field_has_no_focus inner_second
  end

  it 'should give focus only to the outer form_for if the inner fields_for has :autofocus => false' do
    _erbout = first = second = inner_first = inner_second = ''

    form_for @post do |f|
      first = f.text_field :title
      fields_for @author, :autofocus => false do |g|
        inner_first = g.text_field :name
        inner_second = g.text_field :surname
      end
      second = f.text_field :content
    end

    assert_field_has_focus first
    assert_field_has_no_focus inner_first
    assert_field_has_no_focus second
    assert_field_has_no_focus inner_second
  end
end
