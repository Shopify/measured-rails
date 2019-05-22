# frozen_string_literal: true
module Measured::Rails::ActiveRecord::Length
  extend ActiveSupport::Concern

  module ClassMethods
    def measured_length(*fields)
      measured(Measured::Length, *fields)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :include, Measured::Rails::ActiveRecord::Length
end
