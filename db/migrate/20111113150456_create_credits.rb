class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :People
      t.integer :credit_order
      t.string :credit_text

      t.timestamps
    end
    add_index :credits, :People_id
  end
end
