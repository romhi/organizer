class Congregation < ActiveRecord::Base

  belongs_to :city
  validates_presence_of :name, :number, :city_id

end
