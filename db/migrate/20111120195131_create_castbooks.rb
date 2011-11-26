class CreateCastbooks < ActiveRecord::Migration
  def change
    create_table :castbooks do |t|

      t.timestamps
    end
  end
end
