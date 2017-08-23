class CreateSecurities < ActiveRecord::Migration[5.1]
  def change
    create_table :securities do |t|
      t.text :ticker
      t.text :title
      t.text :description
      t.decimal :price, precision: 8, scale: 4
      t.decimal :expreturn, precision: 7, scale: 6
      t.decimal :stddev, precision: 7, scale: 6
      t.decimal :idiosync, precision: 7, scale: 6
      t.decimal :dividend, precision: 8, scale: 4
      t.decimal :divyield, precision: 7, scale: 6
      t.bigint :numshares
      t.decimal :mktcorr, precision: 7, scale: 6

      t.timestamps
    end
  end
end
