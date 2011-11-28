class Person < ActiveRecord::Base
   validates :gender, :inclusion => { :in => %w(Male Female),
     :message => "%{value} is not a valid gender" }
   validates :status, :inclusion => { :in => %w(Active Inactive),
     :message => "%{value} is not a valid status" }
   validates :height_inches, :numericality => { :only_integer => true, 
     :less_than_or_equal_to => 11 } 
   validates :height_feet, :numericality => { :only_integer => true, 
     :less_than_or_equal_to => 7 }
   validates :first_name, :last_name, :presence => true
   validates :email_address, :uniqueness => true
   has_many :Credits
   has_many :Skills
   def full_name
      "#{self.first_name} #{self.last_name}"
   end
end