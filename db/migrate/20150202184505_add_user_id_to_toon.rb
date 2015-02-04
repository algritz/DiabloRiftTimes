class AddUserIdToToon < ActiveRecord::Migration
  def change
    add_column :toons, :user_id, :integer
    add_index :toons, :user_id
  end
end
