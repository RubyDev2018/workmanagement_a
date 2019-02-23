class AddAuthorizerUserIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :authorizer_user_id, :integer
  end
end
