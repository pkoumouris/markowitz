class CreateIntradays < ActiveRecord::Migration[5.1]
  def change
    create_table :intradays do |t|
    	t.references :security, foreign_key: true
    	t.time :time
    	t.date :date
    	t.boolean :updated, default: false
    	t.integer :cardinal360

      	t.timestamps
    end
    add_index :intradays, [:security_id, :created_at]
  end
end
