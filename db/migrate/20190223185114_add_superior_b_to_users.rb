class AddSuperiorBToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :superior_b, :boolean, default: false 
  end
end
