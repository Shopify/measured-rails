require "measured/rails/version"
require "measured"

require "active_support/all"
require "active_record"
require "active_model"
require "active_model/validations"

module Measured
  module Rails
    class Error < StandardError ; end
  end
end

require "measured/rails/active_record"
require "measured/rails/validations"

if defined? Rails
  require "measured/rails/railtie"
end
