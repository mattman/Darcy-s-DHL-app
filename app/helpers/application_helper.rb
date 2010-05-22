module ApplicationHelper
  
  def flash_messages(*names)
     content = []
     names.each do |key|
       value = flash[key]
       content << content_tag(:p, value, :class => "flash #{key}") if value.present?
     end
     if content.empty?
       ""
     else
       content_tag :section, content.sum(ActiveSupport::SafeBuffer.new),
                   :id => "flash-messages"
     end
   end
  
end
