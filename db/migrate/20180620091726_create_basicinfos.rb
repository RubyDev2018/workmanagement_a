class CreateBasicinfos < ActiveRecord::Migration[5.1]
  def change
    create_table :basicinfos do |t|
      t.time :basic_work_time
      t.time :specified_work_time

      t.timestamps
    end
  end
end
