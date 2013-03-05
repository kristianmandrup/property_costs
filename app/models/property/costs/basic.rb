class Property
  class Costs
    module Basic
      extend ActiveSupport::Concern

      included do
        delegate *Property::Costs::Monthly.cost_types, to: :monthly
        delegate *Property::Costs::OneTime.cost_types, to: :one_time

        # delegate *Property::Costs::MonthlyCost.cost_type_setters, to: :monthly
        # delegate *Property::Costs::OneTimeCost.cost_type_setters, to: :one_time

        delegate :cost, to: :monthly

        delegate :deposit_set?, :prepaid_rent_set?, :deposit=, :prepaid_rent=, to: :one_time

        alias_method :total_rent, :cost

        # see BasicDocument in rent_core
        # Works with set_default on update
        set_default(:one_time, :deposit)      { total_rent * deposit_months }
        set_default(:one_time, :prepaid_rent) { total_rent }              
      end

      def deposit_months
        2
      end

      def configured?
        self.one_time && self.monthly
      end

      def configure!
        self.monthly = Property::Costs::Monthly.new costs: self unless self.monthly
        self.one_time = Property::Costs::OneTime.new costs: self unless self.one_time
      end

      module ClassMethods
        def contexts
          [:monthly, :one_time]
        end
      end        

      def to_s
        %Q{
  id: #{id}
  Monthly costs: 
#{monthly}
  One time costs: 
#{one_time}
  }
      end
    end
  end
end