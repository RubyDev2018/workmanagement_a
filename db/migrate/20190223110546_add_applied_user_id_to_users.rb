class AddAppliedUserIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :applied_user_id, :integer, default: 0
  end
end
