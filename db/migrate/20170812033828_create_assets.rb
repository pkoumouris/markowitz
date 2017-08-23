class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.integer :sec
      t.decimal :volume, precision: 13, scale: 4
      t.references :portfolio, foreign_key: true
      t.text :ticker
      t.text :title

      t.timestamps
    end
    add_index :assets, [:portfolio_id, :created_at, :updated_at]
  end
end
