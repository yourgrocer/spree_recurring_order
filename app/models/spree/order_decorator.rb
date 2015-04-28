Spree::Order.class_eval do

  belongs_to :recurring_order

  def recurring?
    !recurring_order.nil?
  end

  def deliver_recurring_order_email
    if self.recurring?
      Spree::OrderMailer.recurring_email(self.id).deliver
    end
  end

  def complete(payment_method)
    self.payments.create!(payment_method: payment_method, amount: self.total)
    self.payment_state = 'paid'
    self.next!
  end

end
