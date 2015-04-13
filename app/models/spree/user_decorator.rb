Spree::User.class_eval do
  has_one :base_list, class_name: "Spree::RecurringList"

  def has_incomplete_order_booked?
    self.last_incomplete_spree_order && self.last_incomplete_spree_order.delivery_date
  end
end
