class Property
  module Cost
    class AvgComparison
      attr_accessor :property

      def initialize property
        @property = property
      end

      def properties
        @properties ||= similar_properties
      end

      def each category = :monthly, &block
        comparisons_for(category).each do |comparison|
          yield comparison
        end
      end

      # cached
      def comparisons_for category = :monthly
        @comparisons ||= begin
          properties.map do |compare_property|
            Property::Cost::Comparison.new category, property, compare_property
          end
        end
      end

      protected

      def similar_properties
        Property.find_similar_to property
      end
    end
  end
end