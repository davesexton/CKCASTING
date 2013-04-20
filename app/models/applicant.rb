class Applicant < ActiveRecord::Base

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
            :address_line_1, :hair_colour, :eye_colour,
            :gaurdian_name_1,
            presence: true

  validates :gender, inclusion: {
    in: %w(Male Female),
    message: "%{value} is not a valid gender" }

  validates :postcode, format: {
    with: /^((([A-PR-UWYZ])([0-9][0-9A-HJKS-UW]?))|(([A-PR-UWYZ][A-HK-Y])([0-9][0-9ABEHMNPRV-Y]?))\s{0,2}(([0-9])([ABD-HJLNP-UW-Z])([ABD-HJLNP-UW-Z])))|(((GI)(R))\s{0,2}((0)(A)(A)))$/,
    message: "is invalid"}

  validates :gaurdian_telephone_1, :gaurdian_telephone_2,
            :gaurdian_telephone_3, :fax, format: {
    allow_nil: true,
    with: /(\s*\(?0\d{4}\)?(\s*|-)\d{3}(\s*|-)\d{3}\s*)|(\s*\(?0\d{3}\)?(\s*|-)\d{3}(\s*|-)\d{4}\s*)|(\s*(7|8)(\d{7}|\d{3}(\-|\s{1})\d{4})\s*)/,
    message: "number is invalid"}

  include Backup
end
