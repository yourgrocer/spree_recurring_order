class CreateRecurringListItem < ActiveRecord::Migration
  def change
    create_table :spree_recurring_list_items do |t|
      t.integer :recurring_list_id
      t.integer :variant_id
      t.integer :quantity
      t.timestamps
    end
  end
end
