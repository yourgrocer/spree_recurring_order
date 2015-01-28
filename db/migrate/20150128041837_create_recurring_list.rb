class CreateRecurringList < ActiveRecord::Migration
  def change
    create_table :spree_recurring_lists do |t|
      t.integer :user_id
      t.timestamps
    end
  end
end
