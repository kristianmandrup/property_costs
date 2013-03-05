class Property
  module Cost
    class Item
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attr_accessor :property, :category, :label, :type, :price

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end

        @label = labelized(type) unless attributes['label']
        @price = price_of(type) unless attributes['price']
      end

      alias_method :name, :type

      delegate :property, to: :category
      delegate :costs,    to: :property

      def self.create_for category, type
        self.new category: category, type: type
      end

      def persisted?
        false
      end

      protected

      def labelized type
        type.to_s.humanize
      end

      def price_of type
        costs.nil? ? 0 : costs.send(type)
      end
    end
  end
end
