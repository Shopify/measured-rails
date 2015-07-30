module Measured::Rails::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def measured(measured_class, *fields)
      options = fields.extract_options!
      options = {}.merge(options)

      measured_class = measured_class.constantize if measured_class.is_a?(String)

      raise Measured::Rails::Error, "Expecting #{ measured_class } to be a subclass of Measured::Measurable" if !measured_class.is_a?(Class) || !measured_class.ancestors.include?(Measured::Measurable)

      options[:class] = measured_class

      fields.map(&:to_sym).each do |field|
        raise Measured::Rails::Error, "The field #{ field } has already been measured" if measured_fields.keys.include?(field)
        measured_fields[field] = options

        # Reader to retrieve measured object
        define_method(field) do
          value = public_send("#{ field }_value")
          unit = public_send("#{ field }_unit")

          return nil unless value && unit

          instance = instance_variable_get("@measured_#{ field }")
          new_instance = begin
            measured_class.new(value, unit)
          rescue Measured::UnitError
            nil
          end

          if instance && instance == new_instance
            instance
          else
            instance_variable_set("@measured_#{ field }", new_instance)
          end
        end

        # Writer to assign measured object
        define_method("#{ field }=") do |incoming|
          if incoming.is_a?(measured_class)
            instance_variable_set("@measured_#{ field }", incoming)
            value_field_name = "#{ field }_value"
            precision = self.column_for_attribute(value_field_name).precision
            scale = self.column_for_attribute(value_field_name).scale
            rounded_to_scale_value = incoming.value.round(scale)
            
            if rounded_to_scale_value.to_i.to_s.length > (precision - scale)
              raise Measured::Rails::Error, "The value #{rounded_to_scale_value} being set for column '#{value_field_name}' has too many significant digits. Please ensure it has no more than #{precision} significant digits."
            end
            public_send("#{ value_field_name }=", rounded_to_scale_value)
            public_send("#{ field }_unit=", incoming.unit)
          else
            instance_variable_set("@measured_#{ field }", nil)
            public_send("#{ field }_value=", nil)
            public_send("#{ field }_unit=", nil)
          end
        end

        # Writer to override unit assignment
        define_method("#{ field }_unit=") do |incoming|
          incoming = measured_class.conversion.to_unit_name(incoming) if measured_class.valid_unit?(incoming)
          write_attribute("#{ field }_unit", incoming)
        end

      end
    end

    def measured_fields
      @measured_fields ||= {}
    end

  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :include, Measured::Rails::ActiveRecord
end
