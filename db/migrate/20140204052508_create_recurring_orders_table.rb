class CreateRecurringOrdersTable < ActiveRecord::Migration
  def change
    create_table :spree_recurring_orders do |t|
      t.integer :original_order_id
      t.timestamps
    end
  end
end
