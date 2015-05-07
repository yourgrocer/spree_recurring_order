Spree::Order.class_eval do

  belongs_to :recurring_order

  def recurring?
    !recurring_order.nil?
  end

  def auto_complete
    #do nothing - this should be overriden
  end

  def deliver_recurring_order_email
    if self.recurring?
      Spree::OrderMailer.recurring_email(self.id).deliver
    end
  end

end
