class AddActiveToRecurringOrder < ActiveRecord::Migration
  def change
    add_column :spree_recurring_orders, :active, :boolean, default: true
  end
end
