class Family < ActiveRecord::Base
  attr_accessible :family_name, :person_id, :members, :image_upload
  attr_reader :title, :get_available_people
  attr_accessor :file_type
  attr_writer :image_upload

  include Backup

  has_many :people

  validates :family_name, presence: true, uniqueness: true

  validates_format_of :file_type,
    with: /^image/,
    allow_nil: true,
    message: "--- you can only upload image files"

  def title
    begin
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
    rescue
      family_name
    end
  end

  def url
    "/family_groups/family/#{id}"
  end

  def image_url
    path = Rails.root.join('public', 'family_images', "#{id}.jpg")
    if FileTest.exist?(path)
      "/family_images/#{id}.jpg?timestamp=#{Time.now.to_i}"
    else
      'default_cast_image.jpg'
    end
  end

  def thumbnail_url
    if FileTest.exist?(Rails.root.join('public', 'family_images', "#{id}.jpg"))
      path = Rails.root.join('public', 'family_thumbs', "#{id}.jpg")
      make_family_thumbnail unless FileTest.exist?(path)
      "/family_thumbs/#{id}.jpg?timestamp=#{Time.now.to_i}"
    else
      'default_cast_image_thumb.jpg'
    end
  end

  def image_upload=(img)
    self.file_type = img.content_type.chomp
    require 'RMagick'

    img.rewind
    img = Magick::Image::from_blob(img.read).first
    img.resize_to_fill!(261, 300)
    #img = img.quantize(256, Magick::GRAYColorspace)

    file_name = Rails.root.join('public', 'family_images', "#{self.id}.jpg")
    img.write(file_name)

    make_family_thumbnail

  end

  def members=(list)
    Person.where('family_id = ?', id).each do |p|
      p.update_attribute(:family_id, nil)
    end
    Person.find(list).each do |p|
      p.update_attribute(:family_id, id)
    end unless list.nil?
  end

  def members
    " "
  end

  def get_available_people
    Person.where('family_id = ? OR family_id IS NULL', self.id).order([:last_name, :first_name])
  end

  private

  def make_family_thumbnail
    require 'RMagick'

    path = Rails.root.join('public', 'family_images', "#{id}.jpg")
    thumb = Rails.root.join('public', 'family_thumbs', "#{id}.jpg")

    img = Magick::Image::read(path).first
    img.crop_resized!(137, 158, Magick::NorthGravity)
    img.write(thumb)
  end

end
