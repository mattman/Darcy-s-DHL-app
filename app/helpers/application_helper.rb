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
 
  def menu_link(*args, &blk)
    content_tag(:li, link_to(*args, &blk), :class => 'menu-item')
  end
  alias ml menu_link
  
  def resources_sidebar_content(name = current_resource_name)
    returning ActiveSupport::SafeBuffer.new do |content|
      content << ml("All #{name.pluralize}", collection_url)
      content << ml("Add #{name}", new_resource_url) if resource_class.can_create?(current_user)
    end
  end

  def resource_sidebar_content(name = current_resource_name)
    returning ActiveSupport::SafeBuffer.new do |content|
      content << ml("View #{name}", resource_url) if resource.can_view?(current_user)
      content << ml("Edit #{name}", edit_resource_url) if resource.can_edit?(current_user)
      content << ml("Remove #{name}", resource_url, :method => :delete,
        :confirm => BHM::Admin.t("confirmation.destroy", :object_name => name)) if resource.can_destroy?(current_user)
    end
  end
     
  def individual_resource_links2(r, name = current_resource_name, opts = {}, &blk)
    items = []
    items << ml(BHM::Admin.t("buttons.show"), resource_url(r)) if r.can_view?(current_user)
    items << ml(BHM::Admin.t("buttons.edit"), edit_resource_url(r)) if r.can_edit?(current_user)
    items << ml(BHM::Admin.t("buttons.destroy"), resource_url(r), :method => :delete,
      :confirm => BHM::Admin.t("confirmation.destroy", :object_name => name)) if r.can_destroy?(current_user)
    if blk.present?
      position = opts.fetch(:at, :before)
      value = capture(&blk)
      position == :before ? items.unshift(value) : items.push(value)
    end
    content_tag(:ul, items.join.html_safe)
  end

  def batch_upload_helper(name, text)
    inner = ActiveSupport::SafeBuffer.new
    inner << text
    inner << " "
    inner << file_field_tag(:"#{name}_file")
    content = content_tag(:label, inner, :for => "#{name}_file")
    content << submit_tag("Upload", :name => nil)
    form_tag(url_for(:"admin_import_#{name}"), :multipart => true, :class => 'importer') do
      concat content
    end
  end

end
