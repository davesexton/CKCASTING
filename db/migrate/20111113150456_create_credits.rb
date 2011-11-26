class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :Person_id
      t.integer :display_order
      t.string :credit_text

      t.timestamps
    end
    add_index :credits, :Person_id
  end
end
