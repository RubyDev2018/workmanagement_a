class AddBasePointsToBasePoints < ActiveRecord::Migration[5.1]
  def change
    add_column :base_points, :name, :string
    add_column :base_points, :attendance_state, :integer, default: 0
  end
end
