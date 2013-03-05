class Property
  class Costs
    class OneTime < Totaller
      include Mongoid::Document
      # include BasicDocument
      
      def self.cost_types
        [:deposit, :prepaid_rent]
      end

      include_concern :base, from: 'Property::Costs'

      embedded_in :costs, class_name: 'Property::Costs', inverse_of: :one_time

      field :deposit_set,      type: Boolean, default: false
      field :prepaid_rent_set, type: Boolean, default: false

      def deposit= value
        super(value)
        if costs
          self.deposit_set      = (value != costs.total_rent * 2)
          save 
        end
      end

      def prepaid_rent= value
        super(value)
        if costs
          self.prepaid_rent_set = (value != costs.total_rent)
          save 
        end
      end

      alias_method :prepaid_rent_set?, :prepaid_rent_set
      alias_method :deposit_set?,      :deposit_set
    end
  end
end