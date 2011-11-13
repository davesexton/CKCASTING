class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :height_feet
      t.integer :height_inches
      t.string :hair_colour
      t.string :eye_colour
      t.string :gender
      t.string :postcode
      t.float :latitude
      t.float :longitude
      t.string :telephone_number
      t.string :email_address
      t.string :status
      t.datetime :last_viewed_at
      t.integer :view_count

      t.timestamps
    end
  end
end
