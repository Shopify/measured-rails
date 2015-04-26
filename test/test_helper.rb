require "rails/all"
require "measured"
require "measured-rails"
require "minitest/autorun"
require "mocha/setup"
require "pry"

require File.expand_path("../dummy/config/environment", __FILE__)

ActiveSupport.test_order = :random

class ActiveSupport::TestCase
  def reset_db
    ActiveRecord::Base.subclasses.each do |model|
      model.delete_all
    end
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
load File.dirname(__FILE__) + '/dummy/db/schema.rb'
