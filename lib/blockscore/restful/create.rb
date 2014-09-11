module BlockScore
  module Restful
    module Create
      module ClassMethods
        def create(options = {})
          # TODO: Fill out create method
          # req :post, 
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end