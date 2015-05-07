class AddAutoCompleteBooleanToRecurringOrder < ActiveRecord::Migration
  def change
    add_column :spree_recurring_orders, :complete_after_create, :bool, default: false 
  end
end
