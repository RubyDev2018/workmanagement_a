class AddRemarkToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remarks, :text
  end
end
