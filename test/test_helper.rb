require "rails"
require "measured"
require "measured-rails"
require "minitest/autorun"
require "mocha/setup"
require "pry"

require File.expand_path("../dummy/config/environment", __FILE__)

ActiveSupport.test_order = :random

class ActiveSupport::TestCase

end
