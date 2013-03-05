class Property
  module RentCost
    extend ActiveSupport::Concern

    included do     
      embeds_one :costs, class_name: 'Property::Costs', inverse_of: :property

      accepts_nested_attributes_for :costs

      delegate :rent, :deposit, :initial_payment, :total_rent, :entrance_cost, :monthly_cost, :one_time_cost, to: :costs

      delegate :total_entrance_cost, :total_monthly_cost, :total_one_time_cost, to: :costs

      field :cost_sqm,      type: Integer, default: 0
      field :cost_sqfeet,   type: Integer, default: 0      

      include_concerns  :cost, for: 'Property'

      validates :costs,   presence: true

      after_initialize do
        self.costs = Property::Costs.new property: self unless self.costs
      end
    end  

    protected

    def update_cost
      # notify change of size! TODO: Use observer pattern?
      update_cost_sqm if respond_to? :sqm
      update_cost_sqfeet if respond_to? :sqfeet
    end    

    def cost_per square_unit = :meter
      case square_unit
      when :meter, :m, :m2, :sqm
        cost.to_f / sqm
      when :feet, :ft, :sqft, :f2, :sqfeet
        cost.to_f / sqfeet
      else
        raise ArgumentError, "Unknwon square size unit: #{square_unit}"
      end
    end    

    def update_cost_sqm
      self.cost_sqm = cost_per :meter
    end

    def update_cost_sqfeet
      self.cost_sqfeet = cost_per :feet
    end      
  end
end
