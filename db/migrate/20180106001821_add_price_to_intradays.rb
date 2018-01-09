class AddPriceToIntradays < ActiveRecord::Migration[5.1]
  def change
    add_column :intradays, :price, :decimal, precision: 12, scale: 2, default: 0.0, null: false
  end
end
