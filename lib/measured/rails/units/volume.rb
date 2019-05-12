module Measured::Rails::ActiveRecord::Volume
  extend ActiveSupport::Concern

  module ClassMethods
    def measured_volume(*fields)
      measured(Measured::Volume, *fields)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :include, Measured::Rails::ActiveRecord::Volume
end
