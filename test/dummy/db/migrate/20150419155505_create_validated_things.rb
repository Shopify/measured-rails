class CreateValidatedThings < ActiveRecord::Migration
  def change
    create_table :validated_things do |t|

      t.decimal :length_value, precision: 10, scale: 2
      t.string :length_unit, limit: 12

      t.decimal :length_true_value, precision: 10, scale: 2
      t.string :length_true_unit, limit: 12

      t.decimal :length_message_value, precision: 10, scale: 2
      t.string :length_message_unit, limit: 12

      t.decimal :length_units_value, precision: 10, scale: 2
      t.string :length_units_unit, limit: 12

      t.decimal :length_units_singular_value, precision: 10, scale: 2
      t.string :length_units_singular_unit, limit: 12

      t.decimal :length_presence_value, precision: 10, scale: 2
      t.string :length_presence_unit, limit: 12

      t.decimal :length_invalid_value, precision: 10, scale: 2
      t.string :length_invalid_unit, limit: 12

      t.timestamps null: false
    end
  end
end
