class CreateEyeColours < ActiveRecord::Migration
  def change
    create_table :eye_colours do |t|
      t.string :eye_colour

      t.timestamps
    end
    EyeColour.create(:eye_colour => 'Black')
    EyeColour.create(:eye_colour => 'Blue')
    EyeColour.create(:eye_colour => 'Blue/Green')
    EyeColour.create(:eye_colour => 'Blue/Grey')
    EyeColour.create(:eye_colour => 'Brown')
    EyeColour.create(:eye_colour => 'Green')
    EyeColour.create(:eye_colour => 'Green/Grey')
    EyeColour.create(:eye_colour => 'Hazel')

  end
end
