class Person < ActiveRecord::Base
  validates :gender, :inclusion => { :in => %w(Male Female),
    :message => "%{value} is not a valid gender" }
  validates :status, :inclusion => { :in => %w(Active Inactive),
    :message => "%{value} is not a valid status" }
  validates :height_inches, :numericality => { :only_integer => true, 
    :less_than_or_equal_to => 11, :allow_nil => true } 
  validates :height_feet, :numericality => { :only_integer => true, 
    :less_than_or_equal_to => 7, :allow_nil => true }
  validates :first_name, :last_name, :presence => true
  validates :email_address, :uniqueness => true
  has_many :Credits
  has_many :Skills
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def url
    "http://www.ckcasting.co.uk/castbook/cast/#{id}"
  end
  def image_url
    "cast_images/#{id}.jpg"
  end
  def thumbnail_url
    "cast_thumbs/#{id}.jpg"
  end
  def skill_list 
    #x = (Skill.where(person_id: id)).collect { |s| s.skill_text }.join(', ')
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
  
  def height_group
    height = (height_feet * 12) + height_inches
    if height < 36 then "Under 3 foot"
    elsif height < 48 then "3 - 4 foot"
    elsif height < 60 then "4 - 5 foot"
    elsif height < 72 then "5 - 6 foot"
    else "Over 6 foot"
    end
  end
end
