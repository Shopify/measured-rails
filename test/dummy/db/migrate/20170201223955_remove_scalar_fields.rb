class RemoveScalarFields < ActiveRecord::Migration
  def change
    remove_column :validated_things, :length_numericality_less_than_than_scalar_value
    remove_column :validated_things, :length_numericality_less_than_than_scalar_unit

    remove_column :validated_things, :length_non_zero_scalar_value
    remove_column :validated_things, :length_non_zero_scalar_unit

    remove_column :validated_things, :length_zero_scalar_value
    remove_column :validated_things, :length_zero_scalar_unit
  end
end
