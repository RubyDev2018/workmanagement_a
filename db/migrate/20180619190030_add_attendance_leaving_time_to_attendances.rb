class AddAttendanceLeavingTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_time_edit, :datetime
    add_column :attendances, :leaving_time_edit, :datetime
  end
end
