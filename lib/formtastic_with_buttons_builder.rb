class FormtasticWithButtonsBuilder < Formtastic::SemanticFormBuilder
  
  def submit(value = "Save changes", options = {})
    @template.content_tag(:button, value, options.reverse_merge(:type => "submit", :id => "#{object_name}_submit"))
  end
  
  # Generates a label, using a safe buffer and a few other things along those lines.
  def label(method, options_or_text=nil, options=nil)
    if options_or_text.is_a?(Hash)
      return "" if options_or_text[:label] == false
      options = options_or_text
      text = options.delete(:label)
    else
      text = options_or_text
      options ||= {}
    end
    # Using a safe buffer, append the label contents follow by required / optional text.
    text = create_safe_buffer do |buffer|
      buffer << (localized_string(method, text, :label) || humanized_attribute_name(method))
      buffer << required_or_optional_string(options.delete(:required))
    end
    # special case for boolean (checkbox) labels, which have a nested input
    text = create_safe_buffer { |b| b << (options.delete(:label_prefix_for_nested_input) || "") } + text
    input_name = options.delete(:input_name) || method
    super(input_name, text, options).gsub(/\?\s*\:\<\/label\>/, "?</label>").gsub(/\?\s*\:\s*\<abbr/, "? <abbr")
  end
  
  def boolean_input(method, options)
    super.gsub(":</label>", "</label>").gsub(": <abbr", " <abbr")
  end
  
  def dob_input(*args)
    options = args.extract_options!
    options.merge!(:start_year => (Time.now.year - 100), :end_year => Time.now.year, :selected => nil)
    args << options
    date_input(*args)
  end
  
  # Implementation of the cancel button that uses
  def commit_button_with_cancel(*args)
    options = args.extract_options!
    text = options.delete(:label) || args.shift
    cancel_options = options.delete(:cancel)
    
    if @object && @object.respond_to?(:new_record?)
      key = @object.new_record? ? :create : :update
      object_human_name = @object.class.model_name.human          # default is UserPost => "Userpost", but i18n may do better ("User post")
      crappy_human_name = @object.class.name.humanize             # UserPost => "Userpost"
      decent_human_name = @object.class.name.underscore.humanize  # UserPost => "User post"
      object_name = (object_human_name == crappy_human_name) ? decent_human_name : object_human_name
    else
      key = :submit
      object_name = @object_name.to_s.send(@@label_str_method)
    end
    
    text = (self.localized_string(key, text, :action, :model => object_name) || ::Formtastic::I18n.t(key, :model => object_name)) unless text.is_a?(::String)
    button_html = options.delete(:button_html) || {}
    button_html.merge!(:class => [button_html[:class], key].compact.join(' '))
    element_class = ['commit', options.delete(:class)].compact.join(' ') # TODO: Add class reflecting on form action.
    accesskey = (options.delete(:accesskey) || @@default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
    button_html = button_html.merge(:accesskey => accesskey) if accesskey 
    
    # Add cancel options.
    inner = self.submit(text, button_html)
    if cancel_options.present?
      inner << @template.content_tag(:span, "or", :class => "or")
      inner << @template.link_to(cancel_options.delete(:text), cancel_options.delete(:url), cancel_options)
    end
    
    template.content_tag(:li, inner, :class => element_class)
  end
  
  # Returns errors converted to a sentence, adding a full stop.
  def error_sentence(errors)
    error_text = errors.to_sentence.strip
    error_text << "." unless %w(? ! . :).include?(error_text[-1, 1])
    template.content_tag(:p, error_text, :class => 'inline-errors')
  end
  
  protected
  
  def create_safe_buffer
    buffer = defined?(ActiveSupport::SafeBuffer) ? ActiveSupport::SafeBuffer.new : ""
    yield buffer if block_given?
    buffer
  end
    
end