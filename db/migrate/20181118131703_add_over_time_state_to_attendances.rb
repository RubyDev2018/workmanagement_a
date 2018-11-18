class AddOverTimeStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_time_state, :integer, default: 0
  end
end
