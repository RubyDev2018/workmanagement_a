class AddBusinessContentToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :business_content, :text
  end
end
