require "test_helper"

class Measured::Rails::ValidationTest < ActiveSupport::TestCase
  setup do
    reset_db
  end

  test "validation measurable: validation leaves a model valid" do
    assert Thing.new.valid?
  end

  test "validation true works by default" do
    assert thing.valid?
    thing.length_unit = "junk"
    refute thing.valid?
    assert_equal ["Length is not a valid unit"], thing.errors.full_messages
  end

  test "validation can override the message" do
    assert thing.valid?
    thing.length_message_unit = "junk"
    refute thing.valid?
    assert_equal ["Length message has a custom failure message"], thing.errors.full_messages
  end

  test "validation may be any valid unit" do
    length_units.each do |unit|
      thing.length_unit = unit
      assert thing.valid?
      thing.length_unit = unit.to_s
      assert thing.valid?
      thing.length = Measured::Length.new(123, unit)
      assert thing.valid?
    end
  end

  test "validation accepts a list of units in any format as an option and only allows them to be valid" do
    thing.length_units_unit = :m
    assert thing.valid?
    thing.length_units_unit = :cm
    assert thing.valid?
    thing.length_units_unit = "cm"
    assert thing.valid?
    thing.length_units_unit = "meter"
    assert thing.valid?
    thing.length_units = Measured::Length.new(3, :cm)
    assert thing.valid?
    thing.length_units_unit = :mm
    refute thing.valid?
    thing.length_units = Measured::Length.new(3, :ft)
    refute thing.valid?
  end

  test "validation lets the unit be singular" do
    thing.length_units_singular_unit = :ft
    assert thing.valid?
    thing.length_units_singular_unit = "feet"
    assert thing.valid?
    thing.length_units_singular_unit = :mm
    refute thing.valid?
    thing.length_units_singular_unit = "meter"
    refute thing.valid?
  end

  test "validation for unit reasons uses the default message" do
    thing.length_units_unit = :mm
    refute thing.valid?
    assert_equal ["Length units is not a valid unit"], thing.errors.full_messages
  end

  test "validation for unit reasons also uses the custom message" do
    thing.length_units_singular_unit = :mm
    refute thing.valid?
    assert_equal ["Length units singular custom message too"], thing.errors.full_messages
  end

  test "validation presence works on measured columns" do
    assert thing.valid?
    thing.length_presence = nil
    refute thing.valid?
    thing.length_presence_unit = "m"
    refute thing.valid?
    thing.length_presence_value = "3"
    assert thing.valid?
  end

  private

  def thing
    @thing ||= ValidatedThing.new(
      length: Measured::Length.new(1, :m),
      length_true: Measured::Length.new(2, :cm),
      length_message: Measured::Length.new(3, :mm),
      length_units: Measured::Length.new(4, :m),
      length_units_singular: Measured::Length.new(5, :ft),
      length_presence: Measured::Length.new(6, :m)
    )
  end

  def length_units
    @length_units ||= [:m, :meter, :cm, :mm, :millimeter, :in, :ft, :feet, :yd]
  end
end
