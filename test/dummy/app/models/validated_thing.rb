class ValidatedThing < ActiveRecord::Base

  measured_length :length
  validates :length, measured: true

  measured_length :length_true
  validates :length_true, measured: true

  measured_length :length_message
  validates :length_message, measured: {message: "has a custom failure message"}

  measured_length :length_units
  validates :length_units, measured: {units: [:meter, "cm"]}

  measured_length :length_units_singular
  validates :length_units_singular, measured: {units: :ft, message: "custom message too"}

  measured_length :length_presence
  validates :length_presence, measured: true, presence: true

end
