class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :phone
      t.string :email
      t.string :address
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
