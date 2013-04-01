class Property
  class Costs
    class Monthly < Totaller
      include Mongoid::Document
      # include BasicDocument

      def self.cost_types
        [:rent, :utilities, :media, :other]
      end

      embedded_in :costs, class_name: 'Property::Costs', inverse_of: :monthly

      validates :rent, :presence => false, :numericality => {:only_integer => true, :greater_than_or_equal => 0}

      include_concern :base, from: 'Property::Costs'

      after_initialize do
        self.rent = 0 unless self.rent
      end

      before_save do
        sync_costs if changed?
      end

      def total
        unless rent && rent >= 0
          raise NoRentDefinedError, "To calculate the monthly total the rent must be set >= 0"
        end
        super
      end

      protected

      def calc_total
        return total
      rescue NoRentDefinedError
        0
      end

      def sync_costs      
        mtotal = calc_total

        if costs
          costs.total_rent = mtotal

          # TODO: dynamic calc
          default_deposit = mtotal * 2
          default_prepaid_rent = mtotal

          costs.deposit = default_deposit unless costs.deposit_set?
          costs.prepaid_rent = default_prepaid_rent unless costs.prepaid_rent_set?
          costs.save
        end
      end        
    end
  end
end