class Food < ActiveRecord::Base
end

class Snack < Food
  measured_weight :portion
end

class Taco < Snack
end
