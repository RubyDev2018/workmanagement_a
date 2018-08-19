class AddSpecifiedWorkTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :specified_work_start_time, :time
    add_column :users, :specified_work_end_time, :time
  end
end
