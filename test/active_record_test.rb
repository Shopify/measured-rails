require "test_helper"

class Measured::Rails::ActiveRecordTest < ActiveSupport::TestCase
  setup do
    reset_db
  end

  test ".measured raises if called with something that isn't a Measured::Measurable" do
    assert_raises Measured::Rails::Error do
      Thing.measured(Object, :field)
    end
  end

  test ".measured raises if called with something that isn't a class" do
    assert_raises Measured::Rails::Error do
      Thing.measured(:not_correct, :field)
    end
  end

  test ".measured raises if you attempt to define a field twice" do
    assert_raises Measured::Rails::Error do
      Thing.measured Measured::Length, :height
    end
  end

  test ".measured defines a reader for the field" do
    assert_equal length, thing.length
  end

  test ".measured defines a writer for the field that returns" do
    assert_equal new_length, thing.length=(new_length)
  end

  test ".measured_fields returns the configuration for all measured fields on the class" do
    expected = {
      length: { class: Measured::Length },
      width: { class: Measured::Length },
      height: { class: Measured::Length },
      total_weight: { class: Measured::Weight },
      extra_weight: { class: Measured::Weight }
    }

    assert_equal expected, Thing.measured_fields
  end

  test "reader returns the exact same object if the values are equivalent" do
    thing.length = new_length
    assert_equal new_length.object_id, thing.length.object_id
  end

  test "reader creates an instance from the _value and _unit columns" do
    thing = Thing.new
    thing.width_value = 23
    thing.width_unit = "ft"
    assert_equal Measured::Length.new(23, :ft), thing.width
  end

  test "reader creates creating an instance from columns caches the same object" do
    thing = Thing.new
    thing.width_value = 23
    thing.width_unit = "ft"
    assert_equal thing.width.object_id, thing.width.object_id
  end

  test "reader deals with only the _value column set" do
    thing = Thing.new
    thing.width_value = 23
    assert_nil thing.width
  end

  test "reader deals with only the _unit column set" do
    thing = Thing.new
    thing.width_unit = "cm"
    assert_nil thing.width
  end

  test "reader deals with nil-ing out the _value column" do
    thing.width_value = nil
    assert_nil thing.width
  end

  test "reader deals with nil-ing out the _unit column" do
    thing.width_unit = nil
    assert_nil thing.width
  end

  test "writer sets the value to nil if it is an incompatible object" do
    thing.length = Object.new
    assert_nil thing.length
  end

  test "writer assigning nil blanks out the unit and value columns" do
    thing.width = nil
    assert_nil thing.width
    assert_nil thing.width_unit
    assert_nil thing.width_value
  end

  test "assigning an invalid _unit sets the column but the measurable object is nil" do
    thing.width_unit = "invalid"
    assert_nil thing.width
    assert_equal "invalid", thing.width_unit
  end

  test "assigning a valid _unit sets it" do
    thing.width_unit = :mm
    assert_equal thing.width, Measured::Length.new(6, "mm")
    assert_equal "mm", thing.width_unit
  end

  test "assigning a non-base unit to _unit converts it to its base unit" do
    thing.width_unit = "millimetre"
    assert_equal thing.width, Measured::Length.new(6, "mm")
    assert_equal "mm", thing.width_unit
  end

  test "building a new object from attributes builds a measured object" do
    thing = Thing.new(length_value: "30", length_unit: "m")
    assert_equal Measured::Length.new(30, :m), thing.length
  end

  test "building a new object with a measured object assigns the properties" do
    thing = Thing.new(length: new_length)
    assert_equal new_length, thing.length
    assert_equal 20, thing.length_value
    assert_equal "in", thing.length_unit
  end

  test "assigning attributes updates the measured object" do
    thing.attributes = {length_value: "30", length_unit: "m"}
    assert_equal Measured::Length.new(30, :m), thing.length
  end

  test "assigning partial attributes updates the measured object" do
    thing.attributes = {length_value: "30"}
    assert_equal Measured::Length.new(30, :cm), thing.length
  end

  test "assigning the _unit leaves the _value unchanged" do
    thing.total_weight_unit = :lb
    assert_equal thing.total_weight, Measured::Weight.new(200, "lb")
  end

  test "assigning the _value leaves the _unit unchanged" do
    thing.total_weight_value = "10"
    assert_equal thing.total_weight, Measured::Weight.new(10, :g)
  end

  test "save persists the attributes and retrieves an object" do
    thing = Thing.new length: Measured::Length.new(3, :m)
    assert thing.save
    assert_equal 3, thing.length_value
    assert_equal "m", thing.length_unit
    thing.reload
    assert_equal 3, thing.length_value
    assert_equal "m", thing.length_unit
  end

  test "save pulls attributes from assigned object" do
    thing = Thing.new total_weight_value: "100", total_weight_unit: :lb
    assert thing.save
    thing.reload
    assert_equal 100, thing.total_weight_value
    assert_equal "lb", thing.total_weight_unit
    assert_equal Measured::Weight.new(100, :lb), thing.total_weight
  end

  test "update_attribute sets only the _value column" do
    thing = Thing.create!
    thing.update_attribute(:width_value, 11)
    assert_nil thing.width
  end

  test "update_attribute sets only the _unit column" do
    thing = Thing.create!
    thing.update_attribute(:width_unit, "cm")
    assert_nil thing.width
  end

  test "update_attribute modifies the _value column" do
    thing.update_attribute(:width_value, 99)
    assert_equal Measured::Length.new(99, :in), thing.width
  end

  test "update_attribute modifies only the _unit column" do
    thing.update_attribute(:width_unit, :cm)
    assert_equal Measured::Length.new(6, :cm), thing.width
  end

  test "update_attribute sets one then the other" do
    thing = Thing.create!
    thing.update_attribute(:width_value, 11.1)
    assert_nil thing.width
    thing.update_attribute(:width_unit, "cm")
    assert_equal Measured::Length.new(11.1, :cm), thing.width
  end

  test "update_attributes sets only the _value column" do
    thing = Thing.create!
    thing.update_attributes(width_value: "314")
    assert_equal 314, thing.width_value
    thing.reload
    assert_equal 314, thing.width_value
    assert_nil thing.width
  end

  test "update_attributes sets only the _unit column" do
    thing = Thing.create!
    thing.update_attributes(width_unit: :cm)
    assert_equal "cm", thing.width_unit
    thing.reload
    assert_equal "cm", thing.width_unit
    assert_nil thing.width
  end

  test "update_attributes sets only the _unit column and converts it" do
    thing = Thing.create!
    thing.update_attributes(width_unit: "inch")
    assert_equal "in", thing.width_unit
    thing.reload
    assert_equal "in", thing.width_unit
  end

  test "update_attributes sets the _unit column to nonsense" do
    thing = Thing.create!
    thing.update_attributes(width_unit: "junk")
    assert_equal "junk", thing.width_unit
    thing.reload
    assert_equal "junk", thing.width_unit
  end

  test "update_attributes sets one column then the other" do
    thing = Thing.create!
    thing.update_attributes(width_unit: "inch")
    assert_nil thing.width
    thing.update_attributes(width_value: "314")
    assert_equal Measured::Length.new(314, :in), thing.width
  end

  test "update_attributes sets both columns" do
    thing = Thing.create!
    thing.update_attributes(width_unit: :cm, width_value: 2)
    assert_equal Measured::Length.new(2, :cm), thing.width
    thing.reload
    assert_equal Measured::Length.new(2, :cm), thing.width
  end

  test "update_attributes modifies the _value column" do
    thing.update_attributes(height_value: 2)
    assert_equal Measured::Length.new(2, :m), thing.height
    thing.reload
    assert_equal Measured::Length.new(2, :m), thing.height
  end

  test "update_attributes modifies only the _unit column" do
    thing.update_attributes(height_unit: "foot")
    assert_equal Measured::Length.new(1, :ft), thing.height
    thing.reload
    assert_equal Measured::Length.new(1, :ft), thing.height
  end

  test "update_attributes modifies the _unit column to be something invalid" do
    thing.update_attributes(height_unit: "junk")
    assert_nil thing.height
    assert_equal "junk", thing.height_unit
    thing.reload
    assert_nil thing.height
    assert_equal "junk", thing.height_unit
  end

  test "update_attributes modifies both columns" do
    thing.update_attributes(height_unit: "mm", height_value: 1.234)
    assert_equal Measured::Length.new(1.234, :mm), thing.height
    thing.reload
    assert_equal Measured::Length.new(1.234, :mm), thing.height
  end

  private

  def length
    @length ||= Measured::Length.new(10, :cm)
  end

  def new_length
    @new_length ||= Measured::Length.new(20, :in)
  end

  def thing
    @thing ||= Thing.create!(
      length: length,
      width: Measured::Length.new(6, :in),
      height: Measured::Length.new(1, :m),
      total_weight: Measured::Weight.new(200, :g),
      extra_weight: Measured::Weight.new(16, :oz)
    )
  end
end
