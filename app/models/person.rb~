class Person < ActiveRecord::Base
  validates :gender, inclusion: { 
    in: %w(Male Female),
    message: "%{value} is not a valid gender" }
  
  validates :status, inclusion: { 
    in: %w(Active Inactive),
    message: "%{value} is not a valid status" }
  
  validates :height_inches, numericality: { 
    only_integer: true, 
    less_than_or_equal_to: 11, 
    allow_nil: true } 
  
  validates :height_feet, numericality: { 
    only_integer: true, 
    less_than_or_equal_to: 7,
    allow_nil: true }
  
  validates :first_name, :last_name, presence: true
  
 # validates :email_address, uniqueness: true
  
  has_many :Credits
  has_many :Skills
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def full_url
    "http://www.ckcasting.co.uk/castbook/cast/#{id}"
  end
  def url
    "/castbook/cast/#{id}"
  end
  def image_url
     "cast_images/#{id}.jpg"
  end
  def thumbnail_url
    path = "./app/assets/images/cast_thumbs/#{id}.jpg"
    make_cast_thumbnail "#{id}.jpg" unless FileTest.exist?(path)
    write_attribute(:thumbnail_url, "cast_thumbs/#{id}.jpg")
  end
  def carousel_url
    path = "./app/assets/images/cast_carousel/#{id}.jpg"
    make_cast_carousel "#{id}.jpg" unless FileTest.exist?(path)
    write_attribute(:carousel_url, "/assets/cast_carousel/#{id}.jpg")
  end
  def skill_list 
    Skill.where(person_id: id).order(:skill_text).collect { |s| s.skill_text }.join(', ')
  end

  def age_group
    age = Date.today.year - date_of_birth.year
    age -= 1 if(Date.today.yday < date_of_birth.yday)
    if age < 3 then "Under 3 years"
    elsif age < 6 then "3 - 6 years"
    elsif age < 9 then "6 - 9 years"
    elsif age < 12 then "9 - 12 years"
    elsif age < 15 then "12 - 15 years"
    elsif age < 18 then "15 - 18 years"
    else "Over 18"
    end
  end
  def age_group_id
    age = Date.today.year - date_of_birth.year
    age -= 1 if(Date.today.yday < date_of_birth.yday)
    if age < 3 then 1
    elsif age < 6 then 2
    elsif age < 9 then 3
    elsif age < 12 then 4
    elsif age < 15 then 5
    elsif age < 18 then 6
    else 7
    end
  end
  
  def height_group
    height = (height_feet * 12) + height_inches
    if height < 36 then "Under 3 foot"
    elsif height < 48 then "3 - 4 foot"
    elsif height < 60 then "4 - 5 foot"
    elsif height < 72 then "5 - 6 foot"
    else "Over 6 foot"
    end
  end
  def height_group_id
    height = (height_feet * 12) + height_inches
    if height < 36 then 1
    elsif height < 48 then 2
    elsif height < 60 then 3
    elsif height < 72 then 4
    else 5
    end
  end
  
  private
   def make_cast_thumbnail img
    require 'RMagick'
    path = "./app/assets/images/cast_images/#{img}"
    thumb = "./app/assets/images/cast_thumbs/#{img}"
    img = Magick::Image::read(path).first
    img = img.crop_resized!(137, 158, Magick::NorthGravity)
    img.write(thumb)
  end
  def make_cast_carousel img
    require 'RMagick'
    path = "./app/assets/images/cast_images/#{img}"
    thumb = "./app/assets/images/cast_carousel/#{img}"
    
    results = Magick::ImageList.new
    
    img = Magick::Image::read(path).first
    #img = img.crop_resized!(120, 138, Magick::NorthGravity)
    img = img.crop_resized!(101, 116, Magick::NorthGravity)
    
    results << img << img.wet_floor(0.5, 1)
    result = results.append(true)
    bg = Magick::Image.new(result.columns, result.rows) {self.background_color = "#FFFFFF"}
    final = bg.composite(result, Magick::NorthGravity, Magick::OverCompositeOp)
    
    final.write(thumb)
  end
end
