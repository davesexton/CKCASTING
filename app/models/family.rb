class Family < ActiveRecord::Base
  attr_accessible :family_name, :person_id
  has_many :people

  def image_url
    path = "./app/assets/images/family_images/#{id}.jpg"
    if FileTest.exist?(path)
      "cast_images/#{id}.jpg"
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
