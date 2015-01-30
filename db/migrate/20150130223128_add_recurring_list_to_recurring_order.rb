class AddRecurringListToRecurringOrder < ActiveRecord::Migration
  def change
    add_column :spree_recurring_lists, :recurring_order_id, :integer
  end
end
