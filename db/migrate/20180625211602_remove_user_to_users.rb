class RemoveUserToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :remarks, :text
  end
end
