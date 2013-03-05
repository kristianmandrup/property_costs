class Property
  class Costs
    module Default
      extend ActiveSupport::Concern

      included do
        after_update do
          set_defaults
        end    
      end

      def set_defaults
        self.class.defaults.each {|meth| send(meth) }
      end

      module ClassMethods
        def defaults
          @defaults ||= []
        end

        def set_default context, fname, value = nil, &block
          raise ArgumentError, "Must take value" unless value || block_given?
          raise ArgumentError, "Must take field name" unless fname
          raise ArgumentError, "Must take context, either" unless contexts.include? context.to_sym

          meth_name = "set_default_#{context}_#{fname}"

          defaults << meth_name

          define_method meth_name do
            ctx = send(context)
            value = block_given? ? instance_eval(&block) : value 

            current_value = ctx.send(fname)
            ctx.send("#{fname}=", value) unless current_value && current_value > 0
          end
        end

        def delegate_fields *names
          options = names.extract_options!
          names.each do |name|
            delegate name, "#{name}=", to: options[:to]
          end
        end

        def monetize_for *names
          names.flatten.each do |name|
            field name, type: Integer, default: 0
          end
        end
      end
    end
  end
end      