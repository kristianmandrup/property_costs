class Property
  class Costs
    include Mongoid::Document    
    # include BasicDocument

    class NoRentDefinedError < StandardError; end

    include_concerns :default, :basic

    include_concerns :cost, from: 'Property' # add cost field and validation

    embeds_one :monthly,   class_name: 'Property::Costs::Monthly', inverse_of: :costs #, :cascade_callbacks => true
    embeds_one :one_time,  class_name: 'Property::Costs::OneTime', inverse_of: :costs #, :cascade_callbacks => true

    embedded_in :property, class_name: 'Property', inverse_of: :costs

    validates :monthly,   presence: true
    validates :one_time,  presence: true

    delegate :rent=, to: :monthly

    accepts_nested_attributes_for :one_time, :monthly

    after_initialize do
      self.monthly = Property::Costs::Monthly.new costs: self unless self.monthly
      self.one_time = Property::Costs::OneTime.new costs: self unless self.one_time
    end

    before_validation do
      self.total_rent = monthly_cost
    end

    alias_method :initial, :one_time

      def to_s
        %Q{
  monthly: 
#{monthly}
  One time: 
#{one_time}
  }
      end


    def categories
      %w{monthly one_time}
    end

    def entrance_cost
      monthly_cost + one_time_cost
    end
    alias_method :total_entrance_cost, :entrance_cost
    alias_method :initial_payment,     :entrance_cost

    def monthly_cost
      monthly ? monthly.cost : 0
    end
    alias_method :total_monthly_cost, :monthly_cost

    def one_time_cost
      one_time ? one_time.cost : 0
    end
    alias_method :total_one_time_cost, :one_time_cost

    def total_rent= rtotal
      if property
        property.cost = rtotal
        # sync cost per sqm and feet
        property.update_cost
      end
    end
  end
end