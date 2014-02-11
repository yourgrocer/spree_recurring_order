class AddNumberToRecurringOrder < ActiveRecord::Migration

  def change
    add_column :spree_recurring_orders, :number, :string
  end

end
