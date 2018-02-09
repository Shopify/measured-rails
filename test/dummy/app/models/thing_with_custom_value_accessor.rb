class ThingWithCustomValueAccessor < ActiveRecord::Base

  measured_length :length, value_field_name: :length_value_number
  validates :length, measured: true

  measured "Measured::Weight", :extra_weight, value_field_name: :extra_number_value
  validates :extra_weight, measured: true
end

