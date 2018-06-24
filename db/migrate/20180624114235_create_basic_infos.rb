class CreateBasicInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :basic_infos do |t|
      t.time :basic_work_time
      t.time :specified_work_time

      t.timestamps
    end
  end
end
