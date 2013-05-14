require 'active_support/core_ext' # needed for reverse_merge

module TableHelper

  def tablegrid_showlink(obj,options={})
    options = options.reverse_merge :label => Tablegrid.config.show_label, :class => Tablegrid.config.show_btn
    options[:url] = url_for(obj) if options[:url].nil?
    options[:class] << "show-hover"
    link_to content_tag(:i, "", :class=> ["icon-search"]) + options[:label], 
            options[:url], 
            options.delete_if {|key, value| [:url,:label].include?(key)}
  end
  
  
  def tablegrid_editlink(obj,options={})
    options = options.reverse_merge :label => Tablegrid.config.edit_label, :class => Tablegrid.config.edit_btn
    options[:url] = url_for([:edit,obj]) if options[:url].nil?
    options[:class] << "show-hover"
    link_to content_tag(:i, "", :class=> ["icon-pencil"]) + options[:label], 
            options[:url], 
            options.delete_if {|key, value| [:url,:label].include?(key)}
  end
  
  
  def tablegrid_destroylink(obj,options={})
    options = options.reverse_merge  :label       => Tablegrid.config.destroy_label,
                                     :class       => Tablegrid.config.destroy_btn,
                                     :confirm     => t("#{obj.class}.delete", :name => "")
    options[:url] = url_for(obj) if options[:url].nil?
    options[:class] << "show-hover"
    options[:method]=:delete
    link_to content_tag(:i, "", :class=> ["icon-trash"]) + options[:label], 
            options[:url], 
            options.delete_if {|key, value| [:url,:label].include?(key)}
  end
  
end