# frozen_string_literal: true
module Measured::Rails::ActiveRecord::Weight
  extend ActiveSupport::Concern

  module ClassMethods
    def measured_weight(*fields)
      measured(Measured::Weight, *fields)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :include, Measured::Rails::ActiveRecord::Weight
end
