class Property
  module Cost
    class Category   
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attr_reader :property, :name, :title

      def initialize property, name, title = nil
        validate_property! property
        @property = property
        @name     = name.to_s
        @title    = title || name.humanize
      end

      def validate_property! property
        raise ArgumentError, "Must be a property, was: #{property}" unless valid_property? property
      end

      def valid_property? property
        property.kind_of?(Property)
      end

      alias_method :label, :title

      def display_total?
        name.to_sym == :monthly
      end

      def one_time
        cost_items.first
      end

      def monthly
        cost_items.last
      end

      def items
        send "#{name}_items"
      end

      def one_time_items
        [item(:deposit), item(:prepaid_rent)]
      end

      def monthly_items
        [item(:rent), item(:utilities), item(:other)]
      end

      def each &block
        cost_items.each{|cost_item| yield cost_item}
      end

      def cost_items
        @cost_items ||= cost_types.inject([]) do |res, type|
          res << cost_item(type)
          res
        end
      end

      def item type
        Hashie::Mash.new name: type, label: labelize(type), price: price_of(type)
      end

      def cost_item type
        Property::Cost::Item.create_for self, type 
      end

      def total_cost
        costs.nil? ? 0 : costs.total        
      end

      def price_of type
        costs.nil? ? 0 : costs.send(type)
      end

      def costs
        @costs ||= property.costs.send(name)
      end

      def cost_labels
        @cost_labels ||= cost_class.cost_types.map{|type| labelize(type) }
      end

      def cost_types
        @cost_types ||= cost_class.cost_types
      end

      # TODO: localize using Yaml file
      def labelize type
        type.to_s.humanize
      end

      # protected

      def cost_class
        "Property::Costs::#{name.camelize}".constantize
      end
    end
  end
end