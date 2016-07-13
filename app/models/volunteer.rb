class Volunteer < ActiveRecord::Base

  belongs_to :congregation
  belongs_to :responsibility
  scope :by_congregation_id, -> congregation_id { where("congregation_id = ?", congregation_id) }
  validates_presence_of :congregation_id, :last_name, :first_name, :age,
                        :convenient_start_time, :convenient_end_time, :will_be_since_8, :car,
                        :will_be_until_17, :outdoor, :phone, :responsibility_id

end
