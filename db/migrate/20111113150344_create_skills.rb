class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.references :People
      t.integer :skill_order
      t.string :skill_text

      t.timestamps
    end
    add_index :skills, :People_id
  end
end
