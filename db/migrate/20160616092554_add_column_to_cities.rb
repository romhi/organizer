class AddColumnToCities < ActiveRecord::Migration
  def change
    add_column :cities, :region_id, :integer
  end
end
