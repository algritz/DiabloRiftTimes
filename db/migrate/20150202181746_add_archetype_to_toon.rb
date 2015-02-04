class AddArchetypeToToon < ActiveRecord::Migration
  def change
    add_column :toons, :archetype_id, :integer
    add_index :toons, :archetype_id
  end
end
