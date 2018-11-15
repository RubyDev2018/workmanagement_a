class AddExpectedEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :expected_end_time, :datetime
  end
end
