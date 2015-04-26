class MeasuredValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, measurable)
    measured_config = record.class.measured_fields[attribute]

    measured_class = measured_config[:class]
    measurable_unit = record.send("#{ attribute }_unit")
    measurable_value = record.send("#{ attribute }_value")

    message = options[:message] || "is not a valid unit"

    if options[:units]
      valid_units = [options[:units]].flatten.map{|u| measured_class.conversion.to_unit_name(u) }
      record.errors.add(attribute, message) unless valid_units.include?(measured_class.conversion.to_unit_name(measurable_unit))
    end

    record.errors.add(attribute, message) unless measured_class.valid_unit?(measurable_unit)
  end
end
