module Tablegrid

  class Railtie < Rails::Railtie
    initializer "tablegrid.initialize" do
    end
  end

end

ActiveSupport.on_load(:action_controller) do
  include Tablegrid::ActionController
end
