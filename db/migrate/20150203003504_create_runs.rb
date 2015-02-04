class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :duration,  null: false
      t.integer :legendary_count
      t.integer :blood_shard_count
      t.integer :duration_full_clear
      t.integer :legendary_count_full_clear
      t.integer :blood_shard_count_full_clear
      t.integer :user_id,  null: false
      t.integer :toon_id,  null: false
      t.integer :difficulty_id,  null: false
      t.integer :player_count,  null: false

      t.timestamps null: false
    end
    add_index :runs, :user_id
    add_index :runs, :toon_id
    add_index :runs, :difficulty_id
    add_index :runs, :player_count

  end
end
