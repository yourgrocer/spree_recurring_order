class AddNextDeliveryDateToRecurringList < ActiveRecord::Migration
  def change
    add_column :spree_recurring_lists, :next_delivery_date, :date
  end
end
