require "pry" unless ENV["CI"]
require "active_support/all"
require "active_record"
require "active_model"

require "measured"
require "measured-rails"
require "minitest/reporters"
require "minitest/autorun"
require "mocha/setup"

ActiveSupport.test_order = :random

# Prevent two reporters from printing
# https://github.com/kern/minitest-reporters/issues/230
# https://github.com/rails/rails/issues/30491
Minitest.load_plugins
Minitest.extensions.delete('rails')
Minitest.extensions.unshift('rails')

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(color: true)]

class ActiveSupport::TestCase
  def reset_db
    ActiveRecord::Base.subclasses.each do |model|
      model.delete_all
    end
  end
end

Dir.glob(File.expand_path("../support/models/*.rb", __FILE__)).each { |r| require r }
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
require_relative "support/schema.rb"
