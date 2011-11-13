class CreateHairColours < ActiveRecord::Migration
  def change
    create_table :hair_colours do |t|
      t.string :hair_colour

      t.timestamps
    end
    HairColour.create(:hair_colour => 'Auburn')
    HairColour.create(:hair_colour => 'Black')
    HairColour.create(:hair_colour => 'Blonde')
    HairColour.create(:hair_colour => 'Brown')
    HairColour.create(:hair_colour => 'Chestnut')
    HairColour.create(:hair_colour => 'Dark Blonde')
    HairColour.create(:hair_colour => 'Dark Brown')
    HairColour.create(:hair_colour => 'Gray')
    HairColour.create(:hair_colour => 'Light Blonde')
    HairColour.create(:hair_colour => 'Light Brown')
    HairColour.create(:hair_colour => 'Red')
    HairColour.create(:hair_colour => 'White')
  end
end
