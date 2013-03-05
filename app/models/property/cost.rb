class Property
  module Cost
    extend ActiveSupport::Concern

    included do
      # for the total of monthly or one_time
      field     :cost, type: Integer,  default: 0
      validates :cost, numericality: {only_integer: true, greater_than_or_equal_to: minimum_cost }
    end

    module ClassMethods 
      def minimum_cost
        0
      end

      def default_value
        1000
      end

      def default_for type = :apartment
        size ? size * default_cost_per_unit : default_value
      end

      def default_cost_per_unit
        50
      end
    end
  end
end