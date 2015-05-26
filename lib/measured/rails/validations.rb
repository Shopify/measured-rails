class MeasuredValidator < ActiveModel::EachValidator
  CHECKS = {
    greater_than: :>,
    greater_than_or_equal_to: :>=,
    equal_to: :==,
    less_than: :<,
    less_than_or_equal_to: :<=,
  }.freeze

  def validate_each(record, attribute, measurable)
    measured_config = record.class.measured_fields[attribute]

    measured_class = measured_config[:class]
    measurable_unit = record.public_send("#{ attribute }_unit")
    measurable_value = record.public_send("#{ attribute }_value")

    return unless measurable_unit.present? || measurable_value.present?

    record.errors.add(attribute, message) if [measurable_unit.blank?, measurable_value.blank?].any?

    record.errors.add(attribute, message) unless measured_class.valid_unit?(measurable_unit)

    if options[:units]
      valid_units = [options[:units]].flatten.map{|u| measured_class.conversion.to_unit_name(u) }
      record.errors.add(attribute, message) unless valid_units.include?(measured_class.conversion.to_unit_name(measurable_unit))
    end

    options.slice(*CHECKS.keys).each do |option, value|
      record.errors.add(attribute, message) unless measurable.public_send(CHECKS[option], value_for(value, record))
    end
  end

  private

  def message
    options[:message] || "is not a valid unit"
  end

  def value_for(key, record)
    value = case key
    when Proc
      key.call(record)
    when Symbol
      record.send(key)
    else
      key
    end

    if value.is_a?(Numeric)
      raise ArgumentError, ":#{ value } is a scalar. Please validate against a Measurable object with correct units" unless value == 0
      return value
    end

    raise ArgumentError, ":#{ value } must be a Measurable object" unless value.is_a?(Measured::Measurable)

    value
  end
end
