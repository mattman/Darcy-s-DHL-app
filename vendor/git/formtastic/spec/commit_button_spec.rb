# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'SemanticFormBuilder#commit_button' do

  include FormtasticSpecHelper
  
  before do
    @output_buffer = ''
    mock_everything
  end

  describe 'when used on any record' do

    before do
      @new_post.stub!(:new_record?).and_return(false)
      @form = semantic_form_for(@new_post) do |builder|
        concat(builder.commit_button)
      end
    end

    it 'should render a commit li' do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li.commit')
    end

    it 'should render an input with a type attribute of "submit"' do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li.commit input[@type="submit"]')
    end

    it 'should render an input with a name attribute of "commit"' do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li.commit input[@name="commit"]')
    end

    it 'should pass options given in :button_html to the button' do
      @new_post.stub!(:new_record?).and_return(false)
      form = semantic_form_for(@new_post) do |builder|
        concat(builder.commit_button('text', :button_html => {:class => 'my_class', :id => 'my_id'}))
      end

      output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li.commit input#my_id')
      output_buffer.should have_tag('li.commit input.my_class')
    end
    
  end

  describe "its accesskey" do
  
    it 'should allow nil default' do
      with_config :default_commit_button_accesskey, nil do
        output_buffer.should_not have_tag('li.commit input[@accesskey]')
      end
    end

    it 'should use the default if set' do
      with_config :default_commit_button_accesskey, 's' do
        @new_post.stub!(:new_record?).and_return(false)
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.commit_button('text', :button_html => {}))
        end
        output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
        output_buffer.should have_tag('li.commit input[@accesskey="s"]')
      end
    end

    it 'should use the value set in options over the default' do
      with_config :default_commit_button_accesskey, 's' do
        @new_post.stub!(:new_record?).and_return(false)
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.commit_button('text', :accesskey => 'o'))
        end
        output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
        output_buffer.should_not have_tag('li.commit input[@accesskey="s"]')
        output_buffer.should have_tag('li.commit input[@accesskey="o"]')
      end
    end

    it 'should use the value set in button_html over options' do
      with_config :default_commit_button_accesskey, 's' do
        @new_post.stub!(:new_record?).and_return(false)
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.commit_button('text', :accesskey => 'o', :button_html => {:accesskey => 't'}))
        end
        output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
        output_buffer.should_not have_tag('li.commit input[@accesskey="s"]')
        output_buffer.should_not have_tag('li.commit input[@accesskey="o"]')
        output_buffer.should have_tag('li.commit input[@accesskey="t"]')
      end
    end

  end

  describe 'when the first option is a string and the second is a hash' do
    
    before do
      @new_post.stub!(:new_record?).and_return(false)
      @form = semantic_form_for(@new_post) do |builder|
        concat(builder.commit_button("a string", :button_html => { :class => "pretty"}))
      end
    end
    
    it "should render the string as the value of the button" do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li input[@value="a string"]')
    end
    
    it "should deal with the options hash" do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li input.pretty')
    end
    
  end

  describe 'when the first option is a hash' do

    before do
      @new_post.stub!(:new_record?).and_return(false)
      @form = semantic_form_for(@new_post) do |builder|
        concat(builder.commit_button(:button_html => { :class => "pretty"}))
      end
    end
    
    it "should deal with the options hash" do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li input.pretty')
    end
    
  end

  describe 'label' do

    # No object
    describe 'when used without object' do
      describe 'when explicit label is provided' do
        it 'should render an input with the explicitly specified label' do
          form = semantic_form_for(:post, :url => 'http://example.com') do |builder|
            concat(builder.commit_button("Click!"))
          end
          output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
          output_buffer.should have_tag('li.commit input[@value="Click!"][@class~="submit"]')
        end
      end

      describe 'when no explicit label is provided' do
        describe 'when no I18n-localized label is provided' do
          before do
            ::I18n.backend.store_translations :en, :formtastic => {:submit => 'Submit {{model}}'}
          end
          
          after do
            ::I18n.backend.reload!
          end
          
          it 'should render an input with default I18n-localized label (fallback)' do
            form = semantic_form_for(:post, :url => 'http://example.com') do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag('li.commit input[@value="Submit Post"][@class~="submit"]')
          end
        end

       describe 'when I18n-localized label is provided' do
         before do
           ::I18n.backend.store_translations :en,
             :formtastic => {
                 :actions => {
                   :submit => 'Custom Submit',
                  }
               }
           ::Formtastic::SemanticFormBuilder.i18n_lookups_by_default = true
         end

         after do
           ::I18n.backend.reload!
         end

         it 'should render an input with localized label (I18n)' do
           ::I18n.backend.store_translations :en,
             :formtastic => {
                 :actions => {
                   :post => {
                     :submit => 'Custom Submit {{model}}'
                    }
                  }
               }
           form = semantic_form_for(:post, :url => 'http://example.com') do |builder|
             concat(builder.commit_button)
           end
           output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
           output_buffer.should have_tag(%Q{li.commit input[@value="Custom Submit Post"][@class~="submit"]})
         end

         it 'should render an input with anoptional localized label (I18n) - if first is not set' do
           form = semantic_form_for(:post, :url => 'http://example.com') do |builder|
             concat(builder.commit_button)
           end
           output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
           output_buffer.should have_tag(%Q{li.commit input[@value="Custom Submit"][@class~="submit"]})
         end

       end
      end
    end

    # New record
    describe 'when used on a new record' do
      before do
        @new_post.stub!(:new_record?).and_return(true)
      end

      describe 'when explicit label is provided' do
        it 'should render an input with the explicitly specified label' do
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.commit_button("Click!"))
          end
          output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
          output_buffer.should have_tag('li.commit input[@value="Click!"][@class~="create"]')
        end
      end

      describe 'when no explicit label is provided' do
        describe 'when no I18n-localized label is provided' do
          before do
            ::I18n.backend.store_translations :en, :formtastic => {:create => 'Create {{model}}'}
          end

          after do
            ::I18n.backend.reload!
          end

          it 'should render an input with default I18n-localized label (fallback)' do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag('li.commit input[@value="Create Post"][@class~="create"]')
          end
        end

        describe 'when I18n-localized label is provided' do
          before do
            ::I18n.backend.store_translations :en,
              :formtastic => {
                  :actions => {
                    :create => 'Custom Create',
                   }
                }
            ::Formtastic::SemanticFormBuilder.i18n_lookups_by_default = true
          end
          
          after do
            ::I18n.backend.reload!
          end

          it 'should render an input with localized label (I18n)' do
            ::I18n.backend.store_translations :en,
              :formtastic => {
                  :actions => {
                    :post => {
                      :create => 'Custom Create {{model}}'
                     }
                   }
                }
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag(%Q{li.commit input[@value="Custom Create Post"][@class~="create"]})
          end

          it 'should render an input with anoptional localized label (I18n) - if first is not set' do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag(%Q{li.commit input[@value="Custom Create"][@class~="create"]})
          end

        end
      end
    end

    # Existing record
    describe 'when used on an existing record' do
      before do
        @new_post.stub!(:new_record?).and_return(false)
      end

      describe 'when explicit label is provided' do
        it 'should render an input with the explicitly specified label' do
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.commit_button("Click!"))
          end
          output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
          output_buffer.should have_tag('li.commit input[@value="Click!"][@class~="update"]')
        end
      end

      describe 'when no explicit label is provided' do
        describe 'when no I18n-localized label is provided' do
          before do
            ::I18n.backend.store_translations :en, :formtastic => {:update => 'Save {{model}}'}
          end
          
          after do
            ::I18n.backend.reload!
          end

          it 'should render an input with default I18n-localized label (fallback)' do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag('li.commit input[@value="Save Post"][@class~="update"]')
          end
        end

        describe 'when I18n-localized label is provided' do
          before do
            ::I18n.backend.reload!
            ::I18n.backend.store_translations :en,
              :formtastic => {
                  :actions => {
                    :update => 'Custom Save',
                   }
                }
            ::Formtastic::SemanticFormBuilder.i18n_lookups_by_default = true
          end

          after do
            ::I18n.backend.reload!
          end
          
          it 'should render an input with localized label (I18n)' do
            ::I18n.backend.store_translations :en,
              :formtastic => {
                  :actions => {
                    :post => {
                      :update => 'Custom Save {{model}}'
                     }
                   }
                }
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag(%Q{li.commit input[@value="Custom Save Post"][@class~="update"]})
          end

          it 'should render an input with anoptional localized label (I18n) - if first is not set' do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.commit_button)
            end
            output_buffer.concat(form) if defined?(ActiveSupport::SafeBuffer)
            output_buffer.should have_tag(%Q{li.commit input[@value="Custom Save"][@class~="update"]})
            ::I18n.backend.store_translations :en, :formtastic => {}
          end

        end
      end
    end
  end
  
  describe 'when the model is two words' do
    before do
      output_buffer = ''
      class ::UserPost
        extend ActiveModel::Naming if defined?(ActiveModel::Naming)
        include ActiveModel::Conversion if defined?(ActiveModel::Conversion)

        def id
        end
        
        def persisted?
        end
        
        # Rails does crappy human_name
        def self.human_name
          "User post"
        end
      end
      @new_user_post = ::UserPost.new
      
      @new_user_post.stub!(:new_record?).and_return(true)
      @form = semantic_form_for(@new_user_post, :url => '') do |builder|
        concat(builder.commit_button())
      end
    end
    
    it "should render the string as the value of the button" do
      output_buffer.concat(@form) if defined?(ActiveSupport::SafeBuffer)
      output_buffer.should have_tag('li input[@value="Create User post"]')
    end
    
  end
    
end
