module Tablegrid
  
  module ActionController
     extend ActiveSupport::Concern

     included do
       helper        HelperMethods
     end

     protected
     
     module HelperMethods
       def table_grid(objects, options={})
         "test"
       end
     end
     
  end
    
end
