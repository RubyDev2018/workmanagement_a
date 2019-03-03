class AddAttendanceTimeBefEditToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_time_bef_edit, :datetime
  end
end
