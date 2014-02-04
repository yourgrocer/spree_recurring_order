class CreateRecurringOrdersTable < ActiveRecord::Migration
  def change
    add_column :spree_orders, :recurring_order_id, :integer, default: nil

    create_table :spree_recurring_orders do |t|
      t.timestamps
    end
  end
end
