class Property
  module Cost
    class Comparison
      attr_accessor :category, :property, :other_property

      def initialize category, property, other_property
        @category = category
        @property = property
        @other_property = other_property
      end

      def self.compare category, property, other_property
        self.new category, property, other_property
      end

      def value
        relative_fraction * 100
      end

      def description
        "#{value}% #{cost_relation}"
      end

      def relation
        fraction > 1 ? :costlier : :cheaper
      end

      protected

      # TODO: localize!
      def cost_relation
        fraction > 1 ? translate(relation) : translate(relation)
      end

      def translate key
        I18n.t [main_key, key.to_s].join('.')
      end

      def main_key
        'property.cost.comparison'
      end

      def relative_fraction
        @relative_fraction ||= fraction > 1 ? (fraction-1) : fraction
      end

      def fraction
        @fraction ||= total_for(property).to_f / total_for(other_property).to_f
      end

      def total_for property
        property.costs.send(category).total
      end
    end
  end
end