class CreateTargetTimes < ActiveRecord::Migration
  def change
    create_table :target_times do |t|
      t.integer :target_time, null: false
      t.integer :difficulty_id, null: false
      t.integer :player_count, null: false

      t.timestamps null: false
    end
  end
end
