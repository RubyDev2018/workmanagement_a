class AddLeavingTimeBefEditToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :leaving_time_bef_edit, :datetime
  end
end
