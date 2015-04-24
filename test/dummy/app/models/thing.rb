class Thing < ActiveRecord::Base

  measured_length :length, :width

  measured Measured::Length, :height

  measured_weight :total_weight

  measured "Measured::Weight", :extra_weight

end
