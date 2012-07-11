class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4
      t.string :postcode
      t.date :date_of_birth
      t.string :gender
      t.integer :height_inches
      t.integer :height_feet
      t.string :hair_colour
      t.string :eye_colour
      t.text :skills
      t.string :gaurdian_name_1
      t.string :gaurdian_telephone_1
      t.string :gaurdian_name_2
      t.string :gaurdian_telephone_2
      t.string :gaurdian_name_3
      t.string :gaurdian_telephone_3
      t.string :email_address
      t.string :fax
      t.text :stage_credits
      t.text :tv_credits
      t.text :film_credits
      t.text :other_credits

      t.timestamps
    end
  end
end
