class Person < ActiveRecord::Base
  scope :active, conditions: {status: 'Active'}
  #scope :get_age_group, lambda { |a| each(age_group_id: a) }

#TODO validate postcode
  validates :gender, inclusion: {
    in: %w(Male Female),
    message: "%{value} is not a valid gender",
    allow_nil: false }

  validates :status, inclusion: {
    in: %w(Active Inactive),
    message: "%{value} is not a valid status" }
  validate :date_of_birth_cannot_be_in_the_furtue
  validate :date_of_birth_cannot_give_age_over_100

  validates :height_inches, numericality: {
    only_integer: true,
    less_than_or_equal_to: 11,
    greater_than_or_equal_to: 0,
    message: 'Height in inches must be a whole number between 0 and 11',
    allow_nil: false }

  validates :height_feet, numericality: {
    only_integer: true,
    less_than_or_equal_to: 7,
    greater_than_or_equal_to: 0,
    message: 'Height in feet must be a whole number between 0 and 7',
    allow_nil: false }

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :Credits
  has_many :Skills

  before_save :update_location

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_location
    if !self.postcode.blank? and (self.latitude.blank? or self.longitude.blank?)
      loc = get_location
      if loc == [0, 0]
        self.latitude = nil
        self.longitude = nil
      elsif loc == [59.95196533203125, 30.318050384521484]
        self.latitude = nil
        self.longitude = nil
      else
        self.latitude = loc[0]
        self.longitude = loc[1]
      end
    end
  end

  def full_url
    "www.ckcasting.co.uk/castbook/cast/#{id}"
  end

  def url
    "/castbook/cast/#{id}"
  end

  def image_url
    path = "./app/assets/images/cast_images/#{id}.jpg"
    if FileTest.exist?(path)
      "cast_images/#{id}.jpg"
    else
      'default_cast_image.jpg'
    end
  end

  def thumbnail_url
    if FileTest.exist?("./app/assets/images/cast_images/#{id}.jpg")
      path = "./app/assets/images/cast_thumbs/#{id}.jpg"
      make_cast_thumbnail "#{id}.jpg" unless FileTest.exist?(path)
      #write_attribute(:thumbnail_url, "cast_thumbs/#{id}.jpg")
      "cast_thumbs/#{id}.jpg"
    else
      'default_cast_image_thumb.jpg'
    end
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
    Person.age_groups.select{|e| date_of_birth >= e[:from].to_date and date_of_birth <= e[:to].to_date}[0][:text]
  end

  def age_group_id
    Person.age_groups.select{|e| date_of_birth >= e[:from].to_date and date_of_birth <= e[:to].to_date}[0][:id]
  end

  def self.age_groups
    now = Time.now.utc
    [{id: 0, text: 'Under 3 years', from: now - 3.years, to: now},
     {id: 1, text: '3 - 6 years', from: now - 6.years, to: now - 3.years},
     {id: 2, text: '6 - 9 years', from: now - 9.years, to: now - 6.years},
     {id: 3, text: '9 - 12 years', from: now - 12.years, to: now - 9.years},
     {id: 4, text: '12 - 15 years', from: now - 15.years, to: now - 12.years},
     {id: 5, text: '15 - 18 years', from: now - 18.years, to: now - 15.years},
     {id: 6, text: 'Over 18', from: now - 200.years, to: now - 18.years}
    ]
  end

  def height_group
    height = (height_feet * 12) + height_inches
    Person.height_groups.select{|e| height >= e[:from] and height <= e[:to] }[0][:text]
  end

  def height_group_id
    height = (height_feet * 12) + height_inches
    Person.height_groups.select{|e| height >= e[:from] and height <= e[:to] }[0][:id]
  end

  def self.height_groups
    [{id: 0, text: 'Under 3 foot', from: 0, to: 36},
     {id: 1, text: '3 - 4 foot', from: 37, to: 48},
     {id: 2, text: '4 - 5 foot', from: 49, to: 60},
     {id: 3, text: '5 - 6 foot', from: 61, to: 72},
     {id: 4, text: 'Over 6 foot', from: 73, to: 200}
    ]
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
    img = img.crop_resized!(101, 116, Magick::NorthGravity)

    results << img << img.wet_floor(0.5, 1)
    result = results.append(true)
    bg = Magick::Image.new(result.columns, result.rows) {self.background_color = "#FFFFFF"}
    final = bg.composite(result, Magick::NorthGravity, Magick::OverCompositeOp)

    final.write(thumb)
  end

  def date_of_birth_cannot_be_in_the_furtue
    if !date_of_birth.blank? and date_of_birth >= Time.now.utc.to_date
      errors.add(:date_of_birth, "date of birth can't be greater than today")
    end
  end

  def date_of_birth_cannot_give_age_over_100
    if !date_of_birth.blank? and date_of_birth <= Time.now.utc.to_date - 100.years
      errors.add(:date_of_birth, "date of birth can't be more than 100 years in the past")
    end
  end

  def get_location
    begin
      require 'open-uri'
      pc = self.postcode.gsub(' ','+')
      doc = open("http://www.maps.google.com?q=#{pc}").read

      lat = doc.to_s.scan(/var viewport_center_lat=(\d*\.\d*);/)[0][0]
      lng = doc.to_s.scan(/var viewport_center_lng=(\d*\.\d*);/)[0][0]
      [lat.to_f, lng.to_f]
    rescue
      [0, 0]

    end
  end

end
