class Applicant < ActiveRecord::Base
#TODO Add applicant validations
  attr_accessible :address_line_1, :address_line_2, :address_line_3,
                  :address_line_4, :date_of_birth, :email_address,
                  :eye_colour, :fax, :film_credits, :first_name,
                  :gaurdian_name_1, :gaurdian_name_2, :gaurdian_name_3,
                  :gaurdian_telephone_1, :gaurdian_telephone_2,
                  :gaurdian_telephone_3, :gender, :hair_colour,
                  :height_feet, :height_inches, :last_name,
                  :other_credits, :postcode, :skills, :stage_credits,
                  :tv_credits

  validates :first_name, :last_name, :email_address, :date_of_birth,
            :postcode, :address_line_1, :hair_colour, :eye_colour,
            :presence => true


  validates :gender, inclusion: {
    in: %w(Male Female),
    message: "%{value} is not a valid gender" }
end
