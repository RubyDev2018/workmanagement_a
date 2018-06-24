class AddUseridToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :user_id, :integer
  end
end
