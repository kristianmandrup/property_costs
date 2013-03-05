class Property
  class Costs
    class Totaller
      # add all costs
      def total
        self.class.cost_types.inject(0) do |sum, cost| 
          value = send(cost) || 0
          sum += value
        end
      end
      alias_method :total_cost, :total
      alias_method :cost,       :total
    end
  end
end