Spree::User.class_eval do
  has_one :base_list, class_name: "Spree::RecurringList"

  def has_active_regular_order?
    self.base_list.recurring_order.active? rescue false
  end

  def has_incomplete_order_booked?
    self.last_incomplete_spree_order && self.last_incomplete_spree_order.delivery_date
  end
end
