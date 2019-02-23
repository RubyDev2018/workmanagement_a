class AddBasePoints1ToBasePoints < ActiveRecord::Migration[5.1]
  def change
    add_column :base_points, :attendance_state0, :string
  end
end
