require "measured/rails/version"
require "measured"

require "rails"

module Measured
  module Rails
  end
end

if defined? Rails
  require "measured/rails/railtie"
end
