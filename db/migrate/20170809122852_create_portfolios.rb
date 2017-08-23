class CreatePortfolios < ActiveRecord::Migration[5.1]
  def change
    create_table :portfolios do |t|
      t.text :title
      t.text :description
      t.numeric :pType, precision: 1, scale: 0, default: 1, null: false
      t.decimal :TOI, precision: 18, scale: 8, default: 1.0, null: false
      t.decimal :cashAUD, precision: 12, scale: 2, default: 0.0, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :portfolios, [:user_id, :created_at]
  end
end
