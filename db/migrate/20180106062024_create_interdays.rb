class CreateInterdays < ActiveRecord::Migration[5.1]
  def change
    create_table :interdays do |t|
    	t.references :security, foreign_key: true
    	t.date :date
    	t.decimal :open, precision: 12, scale: 2
    	t.decimal :close, precision: 12, scale: 2
    	t.decimal :high, precision: 12, scale: 2
    	t.decimal :low, precision: 12, scale: 2

      t.timestamps
    end
  end
end
