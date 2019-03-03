class CreateOneMonthWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :one_month_works do |t|
      t.integer :app_user_id
      t.integer :auth_user_id
      t.date :app_date
      t.integer :application_state, default: 0

      t.timestamps
    end
  end
end
