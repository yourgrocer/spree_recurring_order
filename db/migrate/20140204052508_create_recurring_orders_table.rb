class CreateRecurringOrdersTable < ActiveRecord::Migration
  def change
    add_column :spree_orders, :recurring_order_id, :integer

    create_table :spree_recurring_orders do |t|
      t.text :comments
      t.timestamps
    end
  end
end
