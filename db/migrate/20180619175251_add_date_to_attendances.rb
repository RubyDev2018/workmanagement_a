class AddDateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :day, :date
  end
end
