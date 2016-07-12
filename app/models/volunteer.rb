class Volunteer < ActiveRecord::Base

  belongs_to :congregation
  belongs_to :responsibility

end
