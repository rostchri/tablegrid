require 'active_support/core_ext' # needed for reverse_merge

module TableHelper

  class Table
    #include Haml::Helpers
    
    attr_accessor :options, :id, :viewcontext, :objects

    def initialize(objects,options={},&block)
      # default options
      
      options = options.reverse_merge  :id                 => "tablegrid-#{rand.to_s.split('.').last}", 
                                       :table_class        => Tablegrid.config.table_class,
                                       :vtable_class       => Tablegrid.config.vtable_class,
                                       :heading_class      => Tablegrid.config.heading_class,
                                       :th_class           => Tablegrid.config.th_class,
                                       :tr_class           => Tablegrid.config.tr_class,
                                       :td_class           => Tablegrid.config.td_class,
                                       :numeric_td_class   => Tablegrid.config.numeric_td_class,
                                       :date_td_class      => Tablegrid.config.date_td_class,
                                       :string_td_class    => Tablegrid.config.string_td_class,
                                       :even_odd           => Tablegrid.config.even_odd,
                                       :paginator_pos      => Tablegrid.config.paginator_pos,
                                       :actions            => Tablegrid.config.actions,
                                       :hoveractions       => Tablegrid.config.hoveractions,
                                       :i18n               => Tablegrid.config.i18n,
                                       :table_id           => "tablegrid_#{objects.first.class.to_s.underscore.pluralize}",       # CSS ID of the table
                                       :heading_id         => "tablegrid_head_#{objects.first.class.to_s.underscore.pluralize}",  # CSS class for all TH elements
                                       :format_date        => nil,                  # Time formatter (receives date object, expects string). Example: lambda{|datetime| l datetime, :format => :short} 
                                       :vertical           => false,                # Orientation
                                       :caption            => nil,                  # Caption
                                       :clickable_path     => nil,                  # vertical=false -> lambda{|object|} vertical=true -> lambda{|col|}  row will be clickable via jquery javascript-function and given url 
                                       :paginator          => nil,                  # Paginator
                                       :objects_class      => objects.first.class,  # Class of objects for i18n-localisation
                                       :cell_format        => nil,                  # Cell-Formater for specific columns. Example: {:col => lambda{|obj,value| link_to value, my_path(obj)}}
                                       :col_visible        => nil,                  # Visiblity of specific columns in lamda-syntax
                                       :col_invisible      => nil,                  # Invisiblity of specific columns in lamda-syntax
                                       :display_actions    => true,                 # Show action-links or not
                                       # Any of this will create an 'Actions' column, the lambdas receive the object, and expect a string
                                       :show_action        => nil,                  # lambda{|object| link_to '', my_path(object)}
                                       :edit_action        => nil,                  # lambda{|object|} 
                                       :destroy_action     => nil                   # lambda{|object|}

      if (options[:objects_class])
        options[:table_id]   = "tablegrid_#{options[:objects_class].to_s.underscore.pluralize}"
        options[:heading_id] = "tablegrid_head_#{options[:objects_class].to_s.underscore.pluralize}"
      end

      # set some instance-variables according to option-values
      set :id           => options[:id],
          :viewcontext  => options.delete(:viewcontext),
          :options      => options,
          :objects      => objects
    end
    
    # in viewcontext?
    def viewcontext?
      !viewcontext.nil?
    end    
    
    def set(options, &block)
      unless options.empty?
        options.each { |k,v| self.send("#{k}=",v) } if options.is_a? Hash # set (multiple) instance-variables if options is a hash
         # important to use capture in viewcontext for evaluating blocks so that they not appear in view
        self.send("#{options}=", viewcontext? ? viewcontext.capture(&block) : yield) if block_given? && options.is_a?(Symbol) # set instance-variable to evaluated block if block is given and option is a symbol
      end
      nil
    end

    def render_haml
       return if objects.empty?

       # if row_layout are provided use the names in the row_layout, otherwise find all the to_s attributes and select the keys
       columns = options[:row_layout] ? options[:row_layout] : objects.first.attributes.select{|k,v| v.respond_to?(:to_s)}.collect{|a| a[0]}
       show_action_links = options[:display_actions] && (options[:show_action] || options[:edit_action] || options[:destroy_action])
       
       unless options[:vertical]
         return viewcontext.render "tablegrid/table/objects", :objects => objects, :options => options, :columns => columns, :show_action_links => show_action_links
       else
         return viewcontext.render "tablegrid/table/object", :object => objects.first, :options => options, :columns => columns, :show_action_links => show_action_links
       end

#        content = viewcontext.capture_haml do  
#          viewcontext.haml_tag :div, {:class => "tablegrid", :id => options[:id]} do
#            if [:both,:top].include?(options[:paginator_pos])
#              viewcontext.haml_tag :div, {:class => "tablegrid_paginator_top"} do
#                viewcontext. haml_concat options[:paginator] unless options[:paginator].nil? || objects.num_pages == 1
#              end
#              viewcontext.haml_tag :div, :class => "tablegrid_paginator_clear"
#            end
#            viewcontext.haml_tag :table, {:id => options[:table_id], :class => options[:table_class]} do
#              viewcontext.haml_tag :caption do
#                viewcontext. haml_concat options[:caption]
#              end unless options[:caption].nil?
#              unless options[:vertical] # index-mode
#                # Column headings
#                viewcontext.haml_tag :thead do
#                  viewcontext.haml_tag :tr, { :id => options[:heading_id], :class => [options[:heading_class], options[:tr_class]].join(' ') } do
#                    viewcontext.haml_tag :th, { :class => options[:th_class]} do
#                       viewcontext.haml_concat I18n.t("actions") 
#                    end if show_action_links && options[:actions] == :left
#                    # TODO: sort-order-links
#                    columns.each do |col|
#                      if (options[:col_visible].nil?   ||  options[:col_visible].call(col.to_sym)) &&
#                         (options[:col_invisible].nil? || !options[:col_invisible].call(col.to_sym))   
#                        unless options[:objects_class] && options[:i18n]
#                          viewcontext.haml_tag :th, { :class => options[:th_class]} do 
#                            viewcontext.haml_concat col.to_s.capitalize.humanize 
#                          end
#                        else
#                          viewcontext.haml_tag :th, { :class => options[:th_class]} do 
#                            viewcontext.haml_concat options[:objects_class].human_attribute_name(col) 
#                          end
#                        end
#                      end
#                    end
#                    viewcontext.haml_tag :th, { :class => options[:th_class]} do
#                       viewcontext. haml_concat I18n.t("actions") 
#                    end  if show_action_links && options[:actions] == :right
#                  end
#                end
#                # tbody
#                viewcontext.haml_tag :tbody, :id => "tbody_#{options[:table_id]}" do
# 
#                  objects.each_with_index do |obj,idx|
#                    tr_classes = [ options[:tr_class] ]
#                    tr_classes << ((idx + 1).odd? ? 'odd' : 'even') if options[:even_odd]
#                    viewcontext.haml_tag :tr, {:id => "#{obj.class.to_s.underscore}_#{obj.id}", :class => tr_classes.join(' ')}.merge(options[:clickable_path].nil? ? {}:{:rel=> options[:clickable_path].call(obj)}) do
# 
#                      if show_action_links && options[:actions] == :left
#                        viewcontext.haml_tag :td, { :class => "#{options[:td_class]} actions" } do
#                          [:show_action, :edit_action, :destroy_action].each do |obj_action|        
#                            viewcontext. haml_concat options[obj_action].call(obj) if options[obj_action]
#                          end
#                        end
#                      end
# 
#                      columns.each do |col|
#                        if (options[:col_visible].nil?   ||  options[:col_visible].call(col.to_sym)) &&
#                           (options[:col_invisible].nil? || !options[:col_invisible].call(col.to_sym))   
# 
#                          td_classes  = [options[:td_class], col]
#                          td_classes  << "clickable" unless options[:clickable_path].nil? || options[:clickable_path].call(obj).nil?
#                          td_value    = obj.respond_to?(col) ? obj.send(col) : nil
# 
#                          case td_value.class.to_s
#                          when "String"
#                            td_classes << options[:string_td_class]
#                          when "Numeric"
#                            td_classes << options[:numeric_td_class]
#                          when "Time", "Date", "DateTime","ActiveSupport::TimeWithZone"
#                            td_value = options[:format_date].call(td_value) if options[:format_date]
#                            td_classes << options[:date_td_class]
#                          end
#                          viewcontext.haml_tag :td, {:class => td_classes.join(' ')} do
#                            if options[:cell_format] && options[:cell_format][col]
#                              if obj.respond_to?(col)
#                               viewcontext. haml_concat options[:cell_format][col].call(obj,obj.send(col),idx+1)
#                              else
#                               viewcontext. haml_concat options[:cell_format][col].call(obj,td_value,idx+1)
#                              end
#                            else
#                              viewcontext. haml_concat td_value
#                            end
#                          end
# 
#                        end
#                      end
#                      if show_action_links && options[:actions] == :right
#                        viewcontext.haml_tag :td, { :class => "#{options[:td_class]} actions" } do
#                          [:show_action, :edit_action, :destroy_action].each do |obj_action|        
#                            viewcontext. haml_concat options[obj_action].call(obj) if options[obj_action]
#                          end
#                        end
#                      end
#                    end # end viewcontext.haml_tag :tr                   
#                  end #end objects.each_with_index
#                end # end viewcontext.haml_tag :tbody
#              else # view-mode
#                objects.each do |obj|
#                  columns.each_with_index do |col,idx|
#                    if (options[:col_visible].nil?   ||  options[:col_visible].call(col.to_sym)) &&
#                       (options[:col_invisible].nil? || !options[:col_invisible].call(col.to_sym))   
#                      tr_classes = [ options[:tr_class] ]
# 
#                      # Value
#                      if options[:cell_format] && options[:cell_format][col]
#                        if obj.respond_to?(col)
#                          td_value = options[:cell_format][col].call(obj,obj.send(col),idx+1)
#                        else
#                          td_value = options[:cell_format][col].call(obj,nil,idx+1)
#                        end
#                      else
#                        td_value = obj.send(col)
#                      end
# 
#                      viewcontext.haml_tag :tr, {:class => tr_classes.join(' ') }.merge(options[:clickable_path].nil? ? {} : {:rel=> options[:clickable_path].call(col,obj)}) do
#                        # Column headings  
#                        heading_classes = [options[:heading_class], options[:th_class]]
#                        heading_classes << "clickable" unless options[:clickable_path].nil? || options[:clickable_path].call(col,obj).nil? || options[:clickable_path].call(col,obj).empty?
#                        unless options[:objects_class] && options[:i18n]
#                          viewcontext.haml_tag :th, { :class => heading_classes.join(' ')} do
#                            viewcontext. haml_concat col.to_s.capitalize.humanize 
#                          end
#                        else
#                          viewcontext.haml_tag :th, { :class => heading_classes.join(' ')} do
#                            viewcontext. haml_concat options[:objects_class].human_attribute_name(col) 
#                          end
#                        end
#                        td_classes  = [options[:td_class], col]
#                        td_classes << "clickable" unless options[:clickable_path].nil? || options[:clickable_path].call(col,obj).nil? || options[:clickable_path].call(col,obj).empty?
#                        td_classes  << ((idx + 1).odd? ? 'odd' : 'even') if options[:even_odd]
#                        case td_value.class.to_s
#                        when "String"
#                          td_classes << options[:string_td_class]
#                        when "Numeric"
#                          td_classes << options[:numeric_td_class]
#                        when "Time", "Date", "DateTime","ActiveSupport::TimeWithZone"
#                          td_value = options[:format_date].call(td_value) if options[:format_date]
#                          td_classes << options[:date_td_class]
#                        end
#                        viewcontext.haml_tag :td, { :class => td_classes.join(' '), :id => "#{obj.class.to_s.underscore}_#{obj.id}"} do
#                          viewcontext. haml_concat td_value
#                        end
#                      end
#                    end
#                  end
#                end
#              end
#            end #end viewcontext.haml_tag :table
#            if [:both,:bottom].include?(options[:paginator_pos])
#              viewcontext.haml_tag "div", {:class => "tablegrid_paginator_bottom"} do
#                viewcontext. haml_concat options[:paginator] unless options[:paginator].nil? || objects.num_pages == 1
#              end
#              viewcontext.haml_tag :div, :class => "tablegrid_paginator_clear"
#            end
# 
# #              unless options[:clickable_path].nil?
# #                viewcontext.haml_tag(:script) do
# #                  javascript = <<-EOF
# # //<![CDATA[
# # (function($){
# #  $('th.tablegrid_th.clickable').click(function(){window.location = $(this).closest('tr').attr('rel');})
# #  $('td.tablegrid_td.clickable').click(function(){window.location = $(this).closest('tr').attr('rel');})
# # })(jQuery);
# # //]]>
# # EOF
# #                  viewcontext. haml_concat(javascript)
# #                end
# #              end
#          end
#        end #end viewcontext.capture_haml
#        content
    end
    
    def to_s
      "Table: #{id} #{viewcontext} #{options}"
    end
  end

  def table_grid(objects,options={}, &block)
    table = Table.new(objects,options.merge!({:viewcontext => self}),&block)
    #puts table
    table.render_haml
  end
  
end
