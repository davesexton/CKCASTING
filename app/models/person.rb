class Person < ActiveRecord::Base
  attr_reader :full_name, :full_url, :url, :iamge_url,
              :thumnail_url, :carousel_url, :skill_list,
              :age_group, :age_group_id, :height_group,
              :height_group_id, :hair_colour_group, :has_image, :age
  attr_writer :image_upload
  attr_accessor :file_type
  scope :active, conditions: {status: 'Active'}

#TODO capture user name for edits

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

  validates :file_type, format: {
    with: /^image/,
    message: "--- you can only upload image files",
    allow_nil: true
    }

  validates :postcode, format: {
    allow_nil: true,
    with: /(^$)|(^((([A-PR-UWYZ])([0-9][0-9A-HJKS-UW]?))|(([A-PR-UWYZ][A-HK-Y])([0-9][0-9ABEHMNPRV-Y]?))\s{0,2}(([0-9])([ABD-HJLNP-UW-Z])([ABD-HJLNP-UW-Z])))|(((GI)(R))\s{0,2}((0)(A)(A)))$)/,
    message: "format is invalid"}

  has_many :credits
  has_many :skills
  belongs_to :family

  before_save :update_location

  def full_name
    "#{first_name} #{last_name}"
  end

  def title
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
    path = Rails.root.join('public', 'cast_images', "#{id}.jpg")
    if FileTest.exist?(path)
      "/cast_images/#{id}.jpg"
    else
      'default_cast_image.jpg'
    end
  end

  def thumbnail_url
    if FileTest.exist?(Rails.root.join('public', 'cast_images', "#{id}.jpg"))
      path = Rails.root.join('public', 'cast_thumbs', "#{id}.jpg")
      make_cast_thumbnail unless FileTest.exist?(path)
      "/cast_thumbs/#{id}.jpg"
    else
      'default_cast_image_thumb.jpg'
    end
  end

  def carousel_url
    path = Rails.root.join('public', 'cast_carousel', "#{id}.jpg")
    make_cast_carousel unless FileTest.exist?(path)
    "/cast_carousel/#{id}.jpg"
  end

  def self.has_image
    path = Rails.root.join('public', 'cast_images', '*.jpg')
    ids = Dir[path].map {|f| f.match('\d+')[0]}
    where(id: ids)
  end

  def image_upload=(img)
    self.file_type = img.content_type.chomp

    require 'RMagick'
    img.rewind
    img = Magick::Image::from_blob(img.read).first
    img.resize_to_fill!(261, 300)
    img = img.quantize(256, Magick::GRAYColorspace)

    file_name = Rails.root.join('public', 'cast_images', "#{self.id}.jpg")
    img.write(file_name)
    make_cast_carousel
    make_cast_thumbnail
  end

  def self.has_news
    ids = Credit.where("credit_text LIKE '*%'").pluck(:person_id).uniq
    where(id: ids)
  end

  def news_item
    self.credits.where("credit_text like '*%'").pluck(:credit_text)[0][1..-1]
  end

  def skill_list
    self.skills.order(:display_order).collect { |s| s.skill_text }.join(', ')
  end

  def skill_list=(text)
    self.skills.where(person_id: id).destroy_all
    text.split(',').each_with_index do |s, i|
      self.skills.create(display_order: i, skill_text: s.strip.capitalize)
    end
  end

  def credit_list
    Credit.where(person_id: id).order(:display_order).collect do |s|
      s.credit_text
    end.join("\n")
  end

  def credit_list_array
    Credit.where(person_id: id).order(:display_order).collect do |s|
      s.credit_text
    end
  end

  def credit_list=(text)
    self.credits.destroy_all
    text.split("\n").each_with_index do |s, i|
      s.strip!
      s.gsub!(/\b(Uk|uk)\b/, 'UK')
      self.credits.create(display_order: i, credit_text: s)
    end
  end

  def age
    unless date_of_birth.nil?
      months = (Date.today.year * 12 + Date.today.month) - (date_of_birth.year * 12 + date_of_birth.month)
      (months / 12).to_i
    end
  end

  def age_group
    if date_of_birth
      Person.age_groups.select{|e| date_of_birth >= e[:from].to_date and date_of_birth < e[:to].to_date}[0][:text]
    else
      Person.age_groups.last[:text]
    end
  end

  def age_group_id
    if date_of_birth
      Person.age_groups.select{|e| date_of_birth >= e[:from].to_date and date_of_birth < e[:to].to_date}[0][:id]
    else
      Person.age_groups.last[:id]
    end
  end

  def self.age_groups
    now = Time.now.utc
    [{id: 0, text: 'Under 3 years', from: now - 3.years, to: now},
     {id: 1, text: '3-6 years', from: now - 6.years, to: now - 3.years},
     {id: 2, text: '6-9 years', from: now - 9.years, to: now - 6.years},
     {id: 3, text: '9-12 years', from: now - 12.years, to: now - 9.years},
     {id: 4, text: '12-15 years', from: now - 15.years, to: now - 12.years},
     {id: 5, text: '15-18 years', from: now - 18.years, to: now - 15.years},
     {id: 6, text: 'Over 18 years', from: now - 200.years, to: now - 18.years}
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
    [{id: 0, text: 'Under 3 foot', from: 0, to: 35},
     {id: 1, text: '3-4 foot', from: 36, to: 47},
     {id: 2, text: '4-5 foot', from: 48, to: 59},
     {id: 3, text: '5-6 foot', from: 60, to: 71},
     {id: 4, text: 'Over 6 foot', from: 72, to: 200}
    ]
  end

  def hair_colour_group
    hair_colour.gsub('Light ', '').gsub('Dark ', '')
  end

  def update_last_viewed_at
    if last_viewed_at
      self.view_count += 1 if (Time.now.utc.to_date - last_viewed_at.to_date).to_i > 1
      self.last_viewed_at = Time.now.utc
      self.save
    else
      self.last_viewed_at = Time.now.utc
      self.view_count = 1
    end
  end

  private

  def make_cast_thumbnail
    require 'RMagick'

    path = Rails.root.join('public', 'cast_images', "#{id}.jpg")
    thumb = Rails.root.join('public', 'cast_thumbs', "#{id}.jpg")
    img = Magick::Image::read(path).first
    img.crop_resized!(137, 158, Magick::NorthGravity)
    img.write(thumb)
  end

  def make_cast_carousel
    require 'RMagick'

    path = Rails.root.join('public', 'cast_images', "#{id}.jpg")
    carousel = Rails.root.join('public', 'cast_carousel', "#{id}.jpg")

    if File.exist?(path)
      results = Magick::ImageList.new

      img = Magick::Image::read(path).first
      img.crop_resized!(101, 116, Magick::NorthGravity)

      results << img << img.wet_floor(0.5, 1)
      result = results.append(true)
      bg = Magick::Image.new(result.columns, result.rows) {self.background_color = "#FFFFFF"}
      final = bg.composite(result, Magick::NorthGravity, Magick::OverCompositeOp)

      final.write(carousel)
    end
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
