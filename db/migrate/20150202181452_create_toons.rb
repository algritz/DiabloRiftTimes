class CreateToons < ActiveRecord::Migration
  def change
    create_table :toons do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
