class AddInitialInvestmentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :initial_investment, :decimal, precision: 12, scale: 2, default: 0.0, null: false
  end
end
