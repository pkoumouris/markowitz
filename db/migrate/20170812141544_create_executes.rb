class CreateExecutes < ActiveRecord::Migration[5.1]
  def change
    create_table :executes do |t|
      t.references :portfolio, foreign_key: true
      t.integer :securityID
      t.integer :timeblock
      t.decimal :volume, precision: 13, scale: 4
      t.integer :status

      t.timestamps
    end
    add_index :executes, [:portfolio_id, :securityID]
  end
end
