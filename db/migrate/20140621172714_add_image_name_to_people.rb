class AddImageNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :image_name, :string
    Person.all.each do |p|
      p.image_name = p.id.to_s + '.jpg'
      p.save!
    end
  end
end
