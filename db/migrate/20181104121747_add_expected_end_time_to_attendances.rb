class AddExpectedEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :expected_end_time, :datetime
  end
end
