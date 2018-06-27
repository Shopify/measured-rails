class Animal < ActiveRecord::Base
  measured_weight :average_weight
end

class Bird < Animal
end

class Kakapo < Bird
  validates :average_weight, measured: true
end
