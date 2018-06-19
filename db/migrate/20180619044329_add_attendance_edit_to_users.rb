class AddAttendanceEditToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :attendance_time_edit, :datetime
    add_column :users, :leaving_time_edit, :datetime
  end
end
