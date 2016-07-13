class EditColumnInVolunteer < ActiveRecord::Migration
  def change
    rename_column :volunteers, :service_time_id,  :volunteer_id
  end
end
