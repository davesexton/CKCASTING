class AddImageNameToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :image_name, :string
    Family.all.each do |p|
      p.image_name = p.id.to_s + '.jpg'
      p.save!
    end
  end
end
