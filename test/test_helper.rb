require "rails/all"
require "measured"
require "measured-rails"
require "minitest/autorun"
require "minitest/reporters"
require "mocha/setup"
require "pry" unless ENV["CI"]

require File.expand_path("../dummy/config/environment", __FILE__)

ActiveSupport.test_order = :random

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(color: true)]

class ActiveSupport::TestCase
  def reset_db
    ActiveRecord::Base.subclasses.each do |model|
      model.delete_all
    end
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
load File.dirname(__FILE__) + '/dummy/db/schema.rb'
