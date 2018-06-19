class AddDayToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :day, :date
  end
end
