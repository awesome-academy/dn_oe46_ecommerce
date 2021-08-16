class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: Settings.validate.precision,
                        scale: Settings.validate.scale
      t.integer :quantity
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.timestamp :delete_at

      t.timestamps
    end
  end
end
