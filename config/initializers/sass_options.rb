Sass::Plugin.options.merge!({
  :template_location => File.expand_path(File.join(Rails.root, "app", "stylesheets")), 
  :css_location => File.expand_path(File.join(Rails.root, "public", "stylesheets"))
})