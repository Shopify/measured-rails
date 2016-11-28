class CreateThingWithCustomUnitAccessors < ActiveRecord::Migration[5.0]
  def change
    create_table :thing_with_custom_unit_accessors do |t|
      t.decimal :length_value, precision: 10, scale: 2
      t.decimal :width_value, precision: 10, scale: 2
      t.decimal :height_value, precision: 10, scale: 2

      t.string :size_unit, limit: 12

      t.decimal :total_weight_value, precision: 10, scale: 2, default: 10
      t.decimal :extra_weight_value, precision: 10, scale: 2

      t.string :weight_unit, limit: 12

      t.timestamps null: false
    end
  end
end
