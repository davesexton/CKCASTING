class Family < ActiveRecord::Base
  attr_accessible :family_name, :person_id
  has_many :people

  def title
    if self.people.collect{|p| p.last_name}.uniq.length > 1
      self.people.order([:last_name, :first_name]).collect do|p|
        p.full_name
      end.join(', ').reverse.sub(',', ' dna ').reverse
    else
      self.people.order(:first_name).collect do|p|
        p.first_name
      end.join(', ').reverse.sub(',', ' dna ').reverse + \
      " " + self.people.collect{|p| p.last_name}[0]
    end
  end

  def url
    "/family_groups/family/#{id}"
  end

  def image_url
    path = "./app/assets/images/family_images/#{id}.jpg"
    if FileTest.exist?(path)
      "family_images/#{id}.jpg"
    else
      'default_cast_image.jpg'
    end
  end

  def thumbnail_url
    if FileTest.exist?("./app/assets/images/family_images/#{id}.jpg")
      path = "./app/assets/images/family_thumbs/#{id}.jpg"
      make_family_thumbnail unless FileTest.exist?(path)
      "family_thumbs/#{id}.jpg"
    else
      'default_cast_image_thumb.jpg'
    end
  end

  private

  def make_family_thumbnail
    require 'RMagick'

    path = "./app/assets/images/family_images/#{id}.jpg"
    thumb = "./app/assets/images/family_thumbs/#{id}.jpg"
    img = Magick::Image::read(path).first
    img.crop_resized!(137, 158, Magick::NorthGravity)
    img.write(thumb)
  end

end
