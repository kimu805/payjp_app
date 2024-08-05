class CreateItemOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :item_orders do |t|
      t.references :item, foreign_key: true
      t.timestamps
    end
  end
end
