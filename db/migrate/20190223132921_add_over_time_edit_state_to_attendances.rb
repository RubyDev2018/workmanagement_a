class AddOverTimeEditStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_time_edit_state, :integer, default: 0
  end
end
