class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price, precision: Settings.validate.precision,
                             scale: Settings.validate.scale
      t.decimal :total_price, precision: Settings.validate.precision,
                             scale: Settings.validate.scale

      t.timestamps
    end
  end
end
