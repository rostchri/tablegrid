module Tablegrid
  module ActionController
     extend ActiveSupport::Concern
     included do
       helper        HelperMethods
     end
     protected
     module HelperMethods
       include TableHelper
     end
  end
end
