class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.decimal :length_value, precision: 10, scale: 2
      t.string :length_unit, limit: 12

      t.decimal :width_value, precision: 10, scale: 2
      t.string :width_unit, limit: 12

      t.decimal :height_value, precision: 10, scale: 2
      t.string :height_unit, limit: 12

      t.decimal :total_weight_value, precision: 10, scale: 2, default: 10
      t.string :total_weight_unit, limit: 12, default: "g"

      t.decimal :extra_weight_value, precision: 10, scale: 2
      t.string :extra_weight_unit, limit: 12

      t.decimal :length_with_max_on_assignment_value, precision: 10, scale: 2
      t.string :length_with_max_on_assignment_unit, limit: 12

      t.timestamps null: false
    end
  end
end
