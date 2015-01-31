class AddTimeslotToRecurringList < ActiveRecord::Migration
  def change
    add_column :spree_recurring_lists, :timeslot, :string
  end
end
