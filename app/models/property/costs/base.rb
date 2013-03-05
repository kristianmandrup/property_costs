class Property
  class Costs
    module Base
      extend ActiveSupport::Concern

      included do
        include_concern :default, from: 'Property::Costs'
        include_concern :cost,    from: 'Property'

        monetize_for *cost_types

        cost_types.each do |type|
          define_method "#{type}=" do |value|
            super(value)
            save if costs
          end
        end

        before_validation do
          sync_cost if changed?
        end
      end

      def calc_total
        total
      end

      def sync_cost
        self.cost = calc_total
      end

      def to_s
        str = "    id: #{id}"
        str + str_values
      end

      def str_values
        self.class.all_cost_types.inject("") do |res, type|
          if respond_to?(type)
            begin
              res << "    #{type}: #{send(type)}\n" 
            rescue
              res << "    #{type}: ERROR\n"
            end
          end
          res
        end
      end

      module ClassMethods
        def all_cost_types
          cost_types + [:total, :total_rent]
        end

        def cost_types
          raise NotImplementedError, "Must be implemented by sublclass"
        end

        def self.cost_type_setters
          cost_types.map{|ct| "#{ct}="}
        end        
      end
    end
  end
end