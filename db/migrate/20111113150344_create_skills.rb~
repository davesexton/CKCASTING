class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :Person_id
      t.integer :display_order
      t.string :skill_text

      t.timestamps
    end
    add_index :skills, :Person_id
  end
end
