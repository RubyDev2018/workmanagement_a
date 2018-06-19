class AddAttendanceLeavingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :attendance_time, :datetime
    add_column :users, :leaving_time, :datetime
  end
end
