class AddIndexToInterdaysDate < ActiveRecord::Migration[5.1]
  def change
  	add_index :interdays, [:date, :security_id]
  end
end
