require 'active_support/configurable'

module Tablegrid
  
  # Howto override a global setting: content of config/initializers/tablegrid.rb
  # Tablegrid.configure do |config|
  #   config.actions = :right
  # end
  
  def self.configure(&block)
    yield @config ||= Tablegrid::Configuration.new
  end

  # Global settings for Tablegrid
  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :actions, :hoveractions, :table_class, :vtable_class, :heading_class, :th_class, :tr_class, 
                    :td_class, :numeric_td_class, :string_td_class, :date_td_class, :even_odd, :paginator_pos, :i18n,
                    :show_label, :edit_label, :destroy_label, :show_btn, :edit_btn, :destroy_btn

    # def param_name
    #   config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    # end
  end

  # default global-settings
  configure do |config|
    config.actions                = :left                                                             # location of action-links :left or :right
    config.hoveractions           = false                                                             # action-link appears on hover on corresponding tr
    config.table_class            = ['table', 'table-striped', 'table-bordered', 'table-condensed']   # best used with twitter-bootstrap css framework
    config.vtable_class           = ['vtable']                                                        # CSS class name for vertical - table
    config.heading_class          = 'tablegrid_head'                                                  # CSS class name of the first TR (one containing TH)
    config.th_class               = 'tablegrid_th'                                                    # CSS class for all TH elements
    config.tr_class               = 'tablegrid_tr'                                                    # CSS class for all TR elements
    config.td_class               = 'tablegrid_td'                                                    # CSS class for all TD elements
    config.numeric_td_class       = 'numeric'                                                         # CSS class for any TDs containing a number
    config.string_td_class        = 'string'                                                          # CSS class for any TDs containing a string
    config.date_td_class          = 'date'                                                            # CSS class for any TDs containing a date
    config.even_odd               = false                                                             # Should even/odd classes be added (Not needed for twitter bootstrap css)
    config.paginator_pos          = :both                                                             # Position of Paginator (:botton, :top, :both)
    config.i18n                   = true                                                              # use i18n-localisation for column-names
    config.show_label             = " Anzeigen"                                                       # default text-label for show-button
    config.edit_label             = " Bearbeiten"                                                     # default text-label for edit-button
    config.destroy_label          = " Entfernen"                                                      # default text-label for destroy-button
    config.show_btn               = ["btn", "btn-mini"]                                               # default button for show-button
    config.edit_btn               = ["btn", "btn-mini", "btn-success"]                                # default button for edit-button
    config.destroy_btn            = ["btn", "btn-mini", "btn-danger"]                                 # default button for destroy-button
  end
  
end
