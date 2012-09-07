class Family < ActiveRecord::Base
  attr_accessible :family_name, :person_id
  has_many :people
end
