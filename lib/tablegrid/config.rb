require 'active_support/configurable'

module Tablegrid
  
  # Override global settings for Tablegrid in the following way:
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
    config_accessor :actions

    # def param_name
    #   config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    # end
  end

  # default global-settings
  configure do |config|
    config.actions = :left
  end
end
