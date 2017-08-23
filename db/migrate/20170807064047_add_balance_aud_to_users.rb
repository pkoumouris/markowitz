class AddBalanceAudToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :balanceAUD, :decimal, precision: 12, scale: 2, default: 0.0, null: false
  end
end
