class Skill < ActiveRecord::Base
  belongs_to :person

  include Backup

end
